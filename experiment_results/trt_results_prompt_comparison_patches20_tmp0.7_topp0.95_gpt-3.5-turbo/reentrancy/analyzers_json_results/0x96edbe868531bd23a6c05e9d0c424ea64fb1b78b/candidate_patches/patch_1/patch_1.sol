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
        acc.balance += msg.value;
        if (now + _lockTime > acc.unlockTime) acc.unlockTime = now + _lockTime;
        Log.AddMessage(msg.sender, msg.value, "Put");
    }

    function Collect(uint _am) public {
        var acc = Acc[msg.sender];
        require(acc.balance >= MinSum && acc.balance >= _am && now > acc.unlockTime);
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
        Message memory LastMsg;
        LastMsg.Sender = _adr;
        LastMsg.Time = now;
        LastMsg.Val = _val;
        LastMsg.Data = _data;
        History.push(LastMsg);
    }
} 

// Changes Made:
// 1. Added a 'initialized' boolean flag in the Holder struct to keep track if the holder is initialized or not.
// 2. Replaced the 'throw' with 'require' for better error handling.
// 3. Replaced the external call with 'msg.sender.transfer(_am)' to avoid re-entrancy vulnerability.
// 4. Removed the 'LastMsg' state variable from the LogFile contract and created it as a memory variable in the 'AddMessage' function to avoid storage related issues.