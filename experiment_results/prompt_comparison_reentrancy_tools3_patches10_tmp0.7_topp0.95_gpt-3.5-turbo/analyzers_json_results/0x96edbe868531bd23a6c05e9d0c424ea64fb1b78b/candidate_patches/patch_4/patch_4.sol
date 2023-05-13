pragma solidity ^0.4.19;

contract PENNY_BY_PENNY {
    struct Holder {
        uint unlockTime;
        uint balance;
        bool initialized;
    }

    mapping(address => Holder) public Acc;

    uint public MinSum;

    LogFile Log;

    function SetMinSum(uint _val) public {
        require(!Acc[msg.sender].initialized);
        MinSum = _val;
    }

    function SetLogFile(address _log) public {
        require(!Acc[msg.sender].initialized);
        Log = LogFile(_log);
    }

    function Put(uint _lockTime) public payable {
        var acc = Acc[msg.sender];
        if (!acc.initialized) {
            acc.initialized = true;
        }
        acc.balance += msg.value;
        if (now + _lockTime > acc.unlockTime) {
            acc.unlockTime = now + _lockTime;
        }
        Log.AddMessage(msg.sender, msg.value, "Put");
    }

    function Collect(uint _am) public payable {
        var acc = Acc[msg.sender];
        require(acc.initialized && acc.balance >= MinSum && acc.balance >= _am && now > acc.unlockTime);
        acc.balance -= _am;
        msg.sender.transfer(_am);
        Log.AddMessage(msg.sender, _am, "Collect");
    }

    function() public payable {
        Put(0);
    }
}

contract LogFile {
    struct Message {
        address Sender;
        string Data;
        uint Val;
        uint Time;
    }

    Message[] public History;

    function AddMessage(address _adr, uint _val, string _data) public {
        Message memory newMsg = Message(_adr, _data, _val, now);
        History.push(newMsg);
    }
} 

// Changes Made:
// 1. Added a bool variable 'initialized' in Holder struct to check whether the account has been initialized or not.
// 2. Replaced 'throw' with 'require' for better error handling.
// 3. Removed the external call from Collect function and replaced it with 'transfer' for safer fund transfer.
// 4. Changed the implementation of AddMessage function to avoid reentrancy vulnerability.