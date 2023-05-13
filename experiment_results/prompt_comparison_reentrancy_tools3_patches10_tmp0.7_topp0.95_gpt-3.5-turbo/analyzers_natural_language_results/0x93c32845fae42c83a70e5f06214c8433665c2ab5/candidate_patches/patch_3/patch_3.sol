pragma solidity ^0.4.25;

contract X_WALLET {
    struct Holder {
        uint unlockTime;
        uint balance;
        bool isHolder;
    }

    mapping(address => Holder) public Acc;

    Log LogFile;

    uint public MinSum = 1 ether;

    function X_WALLET(address log) public {
        LogFile = Log(log);
    }

    function Put(uint _unlockTime) public payable {
        require(msg.value > 0, "Value should be greater than 0");
        Holder storage acc = Acc[msg.sender];
        acc.balance += msg.value;
        acc.unlockTime = _unlockTime > now ? _unlockTime : now;
        acc.isHolder = true;
        LogFile.AddMessage(msg.sender, msg.value, "Put");
    }

    function Collect(uint _am) public {
        require(_am > 0, "Amount should be greater than 0");
        Holder storage acc = Acc[msg.sender];
        require(acc.isHolder == true, "No account found for the sender");
        require(acc.balance >= MinSum && acc.balance >= _am && now > acc.unlockTime, "Insufficient balance or account is locked");
        acc.balance -= _am;
        msg.sender.transfer(_am);
        LogFile.AddMessage(msg.sender, _am, "Collect");
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

    Message LastMsg;

    function AddMessage(address _adr, uint _val, string _data) public {
        LastMsg.Sender = _adr;
        LastMsg.Time = now;
        LastMsg.Val = _val;
        LastMsg.Data = _data;
        History.push(LastMsg);
    }
}