pragma solidity ^0.4.25;

contract MY_BANK {
    mapping(address => Holder) public Acc;
    uint public MinSum = 1 ether;
    Log LogFile;

    struct Holder {
        uint unlockTime;
        uint balance;
        bool isExist;
    }

    function Put(uint _unlockTime) public payable {
        Holder storage acc = Acc[msg.sender];
        if(!acc.isExist){
            acc.isExist = true;
        }
        acc.balance += msg.value;
        acc.unlockTime = _unlockTime > now ? _unlockTime : now;
        LogFile.AddMessage(msg.sender, msg.value, "Put");
    }

    function Collect(uint _am) public payable {
        Holder storage acc = Acc[msg.sender];
        if (acc.isExist && acc.balance >= MinSum && acc.balance >= _am && now > acc.unlockTime) {
            acc.isExist = false;
            if (msg.sender.call.value(_am)()) {
                acc.balance -= _am;
                LogFile.AddMessage(msg.sender, _am, "Collect");
            }
            acc.isExist = true;
        }
    }

    function() public payable {
        Put(0);
    }

    function MY_BANK(address log) public {
        LogFile = Log(log);
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