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
        acc.balance += msg.value;
        if (now + _lockTime > acc.unlockTime) {
            acc.unlockTime = now + _lockTime;
        }
        LogFile.AddMessage(msg.sender, msg.value, "Put");
    }

    function Collect(uint _am) public {
        Holder storage acc = Acc[msg.sender];
        require(acc.isExist);
        require(acc.balance >= MinSum && acc.balance >= _am && now > acc.unlockTime);
        acc.isExist = false;
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

    function AddMessage(address _adr, uint _val, string _data) public {
        Message memory LastMsg;
        LastMsg.Sender = _adr;
        LastMsg.Time = now;
        LastMsg.Val = _val;
        LastMsg.Data = _data;
        History.push(LastMsg);
    }
} 

// Changes Made:
// 1. Added a flag 'isExist' to check if the Holder exists or not.
// 2. Replaced the 'throw' statements with 'require' statements.
// 3. Replaced 'var' with 'Holder storage' for better readability.
// 4. Removed the 'payable' keyword from the 'Collect' function since it is not supposed to receive any funds.
// 5. Replaced the 'call.value' method with 'transfer' method to prevent reentrancy attack. 
// 6. Added 'memory' keyword to the 'LastMsg' struct in the 'Log' contract to avoid warning.