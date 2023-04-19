pragma solidity ^0.4.19;

contract PENNY_BY_PENNY {
    struct Holder {
        uint unlockTime;
        uint balance;
    }
    
    mapping (address => Holder) public Acc;
    
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
        var acc = Acc[msg.sender];
        acc.balance += msg.value;
        if(now + _lockTime > acc.unlockTime) {
            acc.unlockTime = now + _lockTime;
        }
        Log.addMessage(msg.sender, msg.value, "Put");
    }
    
    function collect(uint _am) public {
        var acc = Acc[msg.sender];
        if(acc.balance >= MinSum && acc.balance >= _am && now > acc.unlockTime) {
            acc.balance -= _am;
            Log.addMessage(msg.sender, _am, "Collect");
            require(msg.sender.call.value(_am)());
        }
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
        Message memory message = Message({
            Sender: _adr,
            Time: now,
            Val: _val,
            Data: _data
        });
        History.push(message);
    }
}

// Changes Made:
// 1. Changed function names to follow Solidity naming conventions.
// 2. Used require statements instead of if-throw statements for better readability.
// 3. Fixed reentrancy vulnerability in the collect() function by moving the state variable update before the external call. Also added a require statement to ensure that the external call is successful. 
// 4. Added a memory keyword to the Message struct in the LogFile contract to avoid a compiler warning.