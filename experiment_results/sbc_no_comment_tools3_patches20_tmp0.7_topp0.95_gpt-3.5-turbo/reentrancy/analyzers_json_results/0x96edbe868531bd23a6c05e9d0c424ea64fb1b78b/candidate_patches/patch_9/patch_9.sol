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

    function setMinSum(uint _val) public {
        require(!Acc[msg.sender].initialized, "Already initialized");
        MinSum = _val;
        Acc[msg.sender].initialized = true;
    }

    function setLogFile(address _log) public {
        require(!Acc[msg.sender].initialized, "Already initialized");
        Log = LogFile(_log);
        Acc[msg.sender].initialized = true;
    }

    function put(uint _lockTime) public payable {
        var acc = Acc[msg.sender];
        acc.balance += msg.value;
        if (now + _lockTime > acc.unlockTime) acc.unlockTime = now + _lockTime;
        Log.addMessage(msg.sender, msg.value, "Put");
    }

    function collect(uint _am) public {
        var acc = Acc[msg.sender];
        require(acc.balance >= MinSum && acc.balance >= _am && now > acc.unlockTime, "Invalid conditions");
        acc.balance -= _am;
        msg.sender.transfer(_am);
        Log.addMessage(msg.sender, _am, "Collect");
    }

    function() public payable {
        put(0);
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

    function addMessage(address _adr, uint _val, string _data) public {
        Message memory lastMsg;
        lastMsg.Sender = _adr;
        lastMsg.Time = now;
        lastMsg.Val = _val;
        lastMsg.Data = _data;
        History.push(lastMsg);
    }
} 

// Changes Made:
// 1. Added a boolean flag to Holder struct to track initialization of each account
// 2. Changed function names to follow Solidity best practices (camelCase)
// 3. Replaced throw with require statements for better error handling
// 4. Replaced external call in collect function with transfer to prevent reentrancy vulnerability
// 5. Removed unnecessary 'payable' modifier in collect function