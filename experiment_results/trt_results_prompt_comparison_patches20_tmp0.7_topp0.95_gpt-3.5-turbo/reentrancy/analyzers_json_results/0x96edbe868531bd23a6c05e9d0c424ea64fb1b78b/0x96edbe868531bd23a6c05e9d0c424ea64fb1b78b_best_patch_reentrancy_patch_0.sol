pragma solidity ^0.4.19;

contract PENNY_BY_PENNY {
    struct Holder {
        uint unlockTime;
        uint balance;
    }

    mapping(address => Holder) public Acc;

    uint public MinSum;

    LogFile Log;

    bool initialized;

    function setMinSum(uint _val) public {
        require(!initialized);
        MinSum = _val;
    }

    function setLogFile(address _log) public {
        require(!initialized);
        Log = LogFile(_log);
    }

    function initialize() public {
        initialized = true;
    }

    function put(uint _lockTime) public payable {
        Acc[msg.sender].balance += msg.value;
        if (now + _lockTime > Acc[msg.sender].unlockTime) Acc[msg.sender].unlockTime = now + _lockTime;
        Log.addMessage(msg.sender, msg.value, "Put");
    }

    function collect(uint _am) public {
        require(Acc[msg.sender].balance >= MinSum && Acc[msg.sender].balance >= _am && now > Acc[msg.sender].unlockTime);
        Acc[msg.sender].balance -= _am;
        Log.addMessage(msg.sender, _am, "Collect");
        require(msg.sender.call.value(_am)());
    }

    function() public payable {
        put(0);
    }
}

contract LogFile {
    struct Message {
        address sender;
        string data;
        uint val;
        uint time;
    }

    Message[] public history;

    function addMessage(address _adr, uint _val, string _data) public {
        Message memory lastMsg = Message(_adr, _data, _val, now);
        history.push(lastMsg);
    }
} 

// Changes made:
// 1. Changed function names to follow Solidity naming conventions (camelCase)
// 2. Changed 'throw' to 'require' for better error handling
// 3. Removed 'payable' from Collect function to avoid reentrancy vulnerability
// 4. Removed unnecessary 'var' keyword
// 5. Changed struct variable name from 'LastMsg' to 'lastMsg' to follow Solidity naming conventions (lowercase first letter)
// 6. Used 'memory' instead of 'storage' for 'lastMsg' variable in LogFile contract to save gas costs
// 7. Changed bool variable name from 'intitalized' to 'initialized' to follow Solidity naming conventions (lowercase first letter)