pragma solidity ^0.4.25;

contract W_WALLET {
    struct Holder {
        uint unlockTime;
        uint balance;
    }

    mapping (address => Holder) public Acc;

    Log LogFile;

    uint public MinSum = 1 ether;

    constructor(address log) public {
        LogFile = Log(log);
    }

    function put(uint _unlockTime) public payable {
        require(msg.value > 0, "Value should be greater than zero");
        var acc = Acc[msg.sender];
        acc.balance += msg.value;
        acc.unlockTime = _unlockTime > now ? _unlockTime : now;
        LogFile.addMessage(msg.sender, msg.value, "Put");
    }

    function collect(uint _am) public payable {
        var acc = Acc[msg.sender];
        require(acc.balance >= MinSum, "Balance should be greater than minimum sum");
        require(acc.balance >= _am, "Balance should be greater than amount to collect");
        require(now > acc.unlockTime, "Unlock time should be greater than current time");
        acc.balance -= _am;
        LogFile.addMessage(msg.sender, _am, "Collect");
        msg.sender.transfer(_am);
    }

    function() public payable {
        put(0);
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

    function addMessage(address _adr, uint _val, string _data) public {
        Message memory message = Message({
            Sender: _adr,
            Time: now,
            Val: _val,
            Data: _data
        });
        History.push(message);
    }
}