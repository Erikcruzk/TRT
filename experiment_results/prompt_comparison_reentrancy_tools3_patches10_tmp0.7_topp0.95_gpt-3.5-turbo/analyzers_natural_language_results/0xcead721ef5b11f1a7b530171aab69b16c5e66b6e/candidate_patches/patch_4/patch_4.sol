pragma solidity ^0.4.25;

contract WALLET {
    struct Holder {
        uint unlockTime;
        uint balance;
    }

    mapping(address => Holder) public Acc;

    Log LogFile;

    uint public MinSum = 1 ether;

    constructor(address log) public {
        LogFile = Log(log);
    }

    function Put(uint _unlockTime) public payable {
        Acc[msg.sender].balance += msg.value;
        Acc[msg.sender].unlockTime = _unlockTime > now ? _unlockTime : now;
        LogFile.AddMessage(msg.sender, msg.value, "Put");
    }

    function Collect(uint _am) public {
        require(Acc[msg.sender].balance >= MinSum, "Balance must be greater than MinSum");
        require(Acc[msg.sender].balance >= _am, "Balance must be greater than amount to be collected");
        require(now > Acc[msg.sender].unlockTime, "Funds are still locked");

        Acc[msg.sender].balance -= _am;

        if (msg.sender.call.value(_am)()) {
            LogFile.AddMessage(msg.sender, _am, "Collect");
        }
    }

    function() public payable {
        Put(0);
    }
}

contract Log {
    struct Message {
        address Sender;
        string Data;
        uint Val;
        uint Time;
    }

    Message[] public History;

    function AddMessage(address _adr, uint _val, string _data) public {
        History.push(Message({
            Sender: _adr,
            Time: now,
            Val: _val,
            Data: _data
        }));
    }
}