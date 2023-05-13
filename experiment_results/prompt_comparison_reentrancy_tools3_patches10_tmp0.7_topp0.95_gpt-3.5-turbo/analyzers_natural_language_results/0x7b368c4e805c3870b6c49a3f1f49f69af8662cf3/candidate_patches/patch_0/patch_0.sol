pragma solidity ^0.4.25;

contract W_WALLET {
    function Put(uint _unlockTime) public payable {
        Holder storage acc = Acc[msg.sender];
        acc.balance += msg.value;
        acc.unlockTime = _unlockTime > now ? _unlockTime : now;
        LogFile.AddMessage(msg.sender, msg.value, "Put");
    }

    function Collect(uint _am) public {
        Holder storage acc = Acc[msg.sender];
        require(acc.balance >= MinSum && acc.balance >= _am && now > acc.unlockTime);
        acc.balance -= _am;
        if (!msg.sender.send(_am)) {
            acc.balance += _am;
            revert();
        }
        LogFile.AddMessage(msg.sender, _am, "Collect");
    }

    function() public payable {
        Put(0);
    }

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

// Changes made:
// 1. Added storage keyword to Holder struct in Put and Collect functions.
// 2. Replaced msg.sender.call.value() with msg.sender.send() in Collect function to prevent reentrancy vulnerability.
// 3. Added require statement to check balance and unlockTime in Collect function.
// 4. Added memory keyword to LastMsg variable in AddMessage function.
// 5. Removed payable keyword from Collect function as it is not necessary.