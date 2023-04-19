pragma solidity ^0.4.25;

contract W_WALLET {
    struct Holder {   
        uint unlockTime;
        uint balance;
    }

    mapping (address => Holder) public Acc;
    uint public MinSum = 1 ether;

    Log LogFile;

    function W_WALLET(address log) public {
        LogFile = Log(log);
    }

    function Put(uint _unlockTime) public payable {
        require(msg.value > 0, "Value should be greater than zero.");
        var acc = Acc[msg.sender];
        acc.balance += msg.value;
        acc.unlockTime = _unlockTime > now ? _unlockTime : now;
        LogFile.AddMessage(msg.sender, msg.value, "Put");
    }

    function Collect(uint _am) public {
        require(_am > 0, "Amount should be greater than zero.");
        var acc = Acc[msg.sender];
        require(acc.balance >= MinSum, "Balance should be greater than minimum sum.");
        require(acc.balance >= _am, "Balance should be greater than amount.");
        require(now > acc.unlockTime, "Unlock time should be greater than current time.");
        acc.balance -= _am;
        if (msg.sender.call.value(_am)()) {
            LogFile.AddMessage(msg.sender, _am, "Collect");
        } else {
            acc.balance += _am;
        }
    }

    function() public payable {
        Put(0);
    }
}

contract Log {
    struct Message {
        address Sender;
        string  Data;
        uint Val;
        uint  Time;
    }

    Message[] public History;

    function AddMessage(address _adr, uint _val, string _data) public {
        Message memory message = Message({
            Sender: _adr,
            Time: now,
            Val: _val,
            Data: _data
        });
        History.push(message);
    }
}