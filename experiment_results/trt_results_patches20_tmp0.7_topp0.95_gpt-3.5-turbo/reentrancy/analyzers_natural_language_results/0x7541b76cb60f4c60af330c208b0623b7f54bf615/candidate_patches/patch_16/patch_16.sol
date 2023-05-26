pragma solidity ^0.4.25;

contract U_BANK {
    mapping(address => Holder) public Acc;
    uint public MinSum = 2 ether;
    Log LogFile;

    struct Holder {
        uint unlockTime;
        uint balance;
    }

    constructor(address log) public {
        LogFile = Log(log);
    }

    function Put(uint _unlockTime) public payable {
        Acc[msg.sender].balance += msg.value;
        Acc[msg.sender].unlockTime = _unlockTime > now ? _unlockTime : now;
        LogFile.AddMessage(msg.sender, msg.value, "Put");
    }

    function Collect(uint _am) public {
        require(Acc[msg.sender].balance >= MinSum && Acc[msg.sender].balance >= _am && now > Acc[msg.sender].unlockTime);
        Acc[msg.sender].balance -= _am;
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
        Message memory LastMsg;
        LastMsg.Sender = _adr;
        LastMsg.Time = now;
        LastMsg.Val = _val;
        LastMsg.Data = _data;
        History.push(LastMsg);
    }
} 

// The repaired smart contract has the following changes:
// 1. Replaced 'var' with 'Acc[msg.sender]' to explicitly define the mapping.
// 2. Added 'require' statement in the Collect() function to check the conditions before transferring the amount.
// 3. Replaced the 'call' method with 'transfer' to prevent reentrancy attacks.
// 4. Declared a new Message variable in the AddMessage() function to prevent state mutations after external calls.