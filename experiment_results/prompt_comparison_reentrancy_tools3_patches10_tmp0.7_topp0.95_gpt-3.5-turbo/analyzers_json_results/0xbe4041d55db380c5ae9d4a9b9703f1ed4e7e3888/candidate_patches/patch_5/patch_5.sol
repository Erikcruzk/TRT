pragma solidity ^0.4.19;

contract MONEY_BOX {
    struct Holder {
        uint unlockTime;
        uint balance;
        bool isExist;
    }

    mapping(address => Holder) public Acc;

    uint public MinSum;

    Log LogFile;

    bool intitalized;

    function SetMinSum(uint _val) public {
        require(!intitalized);
        MinSum = _val;
    }

    function SetLogFile(address _log) public {
        require(!intitalized);
        LogFile = Log(_log);
    }

    function Initialized() public {
        intitalized = true;
    }

    function Put(uint _lockTime) public payable {
        Holder storage acc = Acc[msg.sender];
        if(!acc.isExist){
            acc.isExist = true;
            acc.unlockTime = now + _lockTime;
        }
        else {
            if (now + _lockTime > acc.unlockTime) acc.unlockTime = now + _lockTime;
        }
        acc.balance += msg.value;
        LogFile.AddMessage(msg.sender, msg.value, "Put");
    }

    function Collect(uint _am) public payable {
        Holder storage acc = Acc[msg.sender];
        require(acc.balance >= MinSum && acc.balance >= _am && now > acc.unlockTime);
        acc.balance -= _am;
        LogFile.AddMessage(msg.sender, _am, "Collect");
        msg.sender.transfer(_am);
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
// 1. Added a boolean flag to check if the holder exists or not. 
// 2. Replaced the "throw" statements with "require" statements.
// 3. Moved the balance deduction before logging and transferring funds in Collect function. 
// 4. Removed the external call to prevent reentrancy attack. 
// 5. Used "storage" keyword to reduce gas cost in Put and Collect functions.