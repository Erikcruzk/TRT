pragma solidity ^0.4.19;

contract DEP_BANK {
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
        Message memory lastMsg = Message({
            sender: _adr,
            time: now,
            val: _val,
            data: _data
        });
        history.push(lastMsg);
    }
} 

// Changes made:
// 1. Renamed functions and variables to follow Solidity naming conventions
// 2. Replaced "throw" with "require" for better readability and error messaging
// 3. Removed unnecessary "payable" modifier from collect() function
// 4. Moved state variable updates before external function call to prevent reentrancy vulnerability.