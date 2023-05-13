pragma solidity ^0.4.25;

contract W_WALLET {
    struct Holder {
        uint unlockTime;
        uint balance;
    }
    
    mapping(address => Holder) public Acc;

    uint public MinSum = 1 ether;

    Log LogFile;

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
        History.push(Message(_adr, _data, _val, now));
    }
} 

// Changes Made
// 1. Removed the usage of var and replaced it with the actual type
// 2. Added the require statement in the Collect function to check for the required conditions before transferring the funds
// 3. Replaced the external call in the Collect function with a direct transfer to avoid the re-entrancy vulnerability
// 4. Moved the struct Holder declaration above the mapping Acc declaration in the W_WALLET contract
// 5. Added the constructor keyword to the constructor function in the W_WALLET contract