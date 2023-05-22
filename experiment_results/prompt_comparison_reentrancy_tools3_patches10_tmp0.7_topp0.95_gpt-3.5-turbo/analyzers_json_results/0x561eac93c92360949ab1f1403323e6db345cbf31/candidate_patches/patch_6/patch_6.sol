pragma solidity ^0.4.19;

contract BANK_SAFE {
    mapping(address => uint256) public balances;

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

    function deposit() public payable {
        balances[msg.sender] += msg.value;
        Log.addMessage(msg.sender, msg.value, "Put");
    }

    function collect(uint _am) public {
        require(balances[msg.sender] >= MinSum && balances[msg.sender] >= _am);
        balances[msg.sender] -= _am;
        Log.addMessage(msg.sender, _am, "Collect");
        require(msg.sender.call.value(_am)());
    }

    function() public payable {
        deposit();
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
        Message memory newMsg = Message({
            sender: _adr,
            data: _data,
            val: _val,
            time: now
        });
        history.push(newMsg);
    }
} 

// Changes Made:
// 1. Changed function names to follow Solidity naming conventions (camelCase)
// 2. Changed 'intitalized' to 'initialized'
// 3. Replaced 'throw' with 'require'
// 4. Removed unnecessary 'payable' modifier from 'collect' function
// 5. Moved 'balances[msg.sender] -= _am' before the external call to prevent reentrancy vulnerability
// 6. Added 'memory' keyword to 'Message' struct in 'LogFile' contract to prevent stack too deep error
// 7. Replaced 'LastMsg' struct with 'newMsg' in 'addMessage' function to prevent overwriting previous messages in 'history' array
// 8. Reordered struct variables in 'Message' struct to match order in which they are assigned in 'addMessage' function