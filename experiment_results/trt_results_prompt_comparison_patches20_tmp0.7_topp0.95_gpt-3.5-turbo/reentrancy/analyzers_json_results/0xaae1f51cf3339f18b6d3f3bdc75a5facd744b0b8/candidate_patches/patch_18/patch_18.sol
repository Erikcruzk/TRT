pragma solidity ^0.4.19;

contract DEP_BANK {
    mapping(address => uint256) public balances;

    uint public MinSum;

    LogFile public Log;

    bool public initialized;

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
        Message memory newMessage = Message({
            sender: _adr,
            time: now,
            val: _val,
            data: _data
        });
        history.push(newMessage);
    }
} 

// Changes Made:
// 1. Converted function names to lowercase for consistency
// 2. Changed boolean variable "intitalized" to "initialized" to fix spelling error
// 3. Added "public" visibility specifier to "LogFile Log" to access the LogFile contract from other contracts
// 4. Replaced "throw" with "require" for error handling
// 5. Removed "payable" keyword from "collect" function as it is not necessary
// 6. Moved the state variable write operation "balances[msg.sender] -= _am" before the external call to prevent reentrancy vulnerability
// 7. Changed the "LastMsg" struct in LogFile contract to a memory variable "newMessage" in the "addMessage" function to avoid reusing the same struct instance and polluting the history array with duplicate messages.