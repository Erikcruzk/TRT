pragma solidity ^0.4.25;

contract U_BANK {
    mapping(address => Holder) public Acc;

    uint public MinSum = 2 ether;

    Log LogFile;

    struct Holder {
        uint unlockTime;
        uint balance;
        bool isLocked;
    }

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
        require(
            acc.balance >= MinSum && acc.balance >= _am && now > acc.unlockTime && !acc.isLocked,
            "Insufficient balance or locked account"
        );
        acc.isLocked = true;
        if (msg.sender.call.value(_am)()) {
            acc.balance -= _am;
            LogFile.AddMessage(msg.sender, _am, "Collect");
        }
        acc.isLocked = false;
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

// Changes Made:
// 1. Moved the struct declaration to the top for better readability
// 2. Added a bool isLocked in the Holder struct to prevent reentrancy attacks
// 3. Added a require statement in the Collect function to check for sufficient balance and unlocked account
// 4. Added the isLocked flag to prevent reentrancy attacks
// 5. Removed the payable modifier from the Collect function as it doesn't need to receive any ether
// 6. Removed the var keyword and used the storage keyword for better readability and optimization. 
// 7. Changed the constructor function to the new constructor syntax.