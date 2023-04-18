pragma solidity ^0.4.25;

contract MY_BANK {
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

    function AddMessage(address _adr, uint _val, string _data) public {
        Message memory lastMsg;
        lastMsg.Sender = _adr;
        lastMsg.Time = now;
        lastMsg.Val = _val;
        lastMsg.Data = _data;
        History.push(lastMsg);
    }
} 

// Changes Made:
// - Moved the struct Holder above the mapping Acc as it is used in the mapping
// - Added storage keyword to acc variable in Put() and Collect() functions
// - Replaced msg.sender.call.value()() with msg.sender.transfer() in Collect() function to prevent reentrancy vulnerability
// - Added require statement in Collect() function to check if the account has enough balance and has already passed the unlock time
// - Removed payable keyword from Collect() function as it was not necessary and could cause issues with the transfer() function
// - Added memory keyword to lastMsg variable in AddMessage() function as it is a local variable and does not need to be stored in storage
// - Initialized lastMsg variable in AddMessage() function to prevent overwriting previous messages in History array
// - Removed duplicate push() function call in AddMessage() function