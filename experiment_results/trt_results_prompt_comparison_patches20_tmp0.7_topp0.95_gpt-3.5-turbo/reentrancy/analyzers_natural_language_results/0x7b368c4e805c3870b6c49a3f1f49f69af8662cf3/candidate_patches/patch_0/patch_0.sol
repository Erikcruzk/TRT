pragma solidity ^0.4.25;

contract W_WALLET {
    mapping(address => Holder) public Acc;
    Log LogFile;
    uint public MinSum = 1 ether;

    struct Holder {
        uint unlockTime;
        uint balance;
        bool locked;
    }

    constructor(address log) public {
        LogFile = Log(log);
    }

    function Put(uint _unlockTime) public payable {
        Acc[msg.sender].balance += msg.value;
        if (_unlockTime > now) {
            Acc[msg.sender].unlockTime = _unlockTime;
        } else {
            Acc[msg.sender].unlockTime = now;
        }
        LogFile.AddMessage(msg.sender, msg.value, "Put");
    }

    function Collect(uint _am) public {
        Holder storage acc = Acc[msg.sender];
        require(acc.balance >= MinSum && acc.balance >= _am && now > acc.unlockTime && !acc.locked);
        acc.locked = true;
        if (msg.sender.call.value(_am)()) {
            acc.balance -= _am;
            acc.locked = false;
            LogFile.AddMessage(msg.sender, _am, "Collect");
        } else {
            acc.locked = false;
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
        Message memory LastMsg;
        LastMsg.Sender = _adr;
        LastMsg.Time = now;
        LastMsg.Val = _val;
        LastMsg.Data = _data;
        History.push(LastMsg);
    }
}