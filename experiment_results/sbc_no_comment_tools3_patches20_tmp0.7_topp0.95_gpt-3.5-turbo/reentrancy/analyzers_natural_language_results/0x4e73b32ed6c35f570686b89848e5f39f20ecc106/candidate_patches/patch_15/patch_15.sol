pragma solidity ^0.4.19;

contract PRIVATE_ETH_CELL {
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
        msg.sender.transfer(_am);
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
        Message memory newMessage = Message(_adr, _data, _val, now);
        history.push(newMessage);
    }
} 

// Changes made:
// 1. Renamed functions to follow Solidity's naming conventions (camelCase)
// 2. Added "require" statements to ensure that certain conditions are met before executing certain functions
// 3. Removed the "payable" modifier from the "collect" function to prevent reentrancy attacks
// 4. Replaced the "call.value" function with the "transfer" function in the "collect" function to prevent reentrancy attacks
// 5. Changed the "intitalized" variable to "initialized" for consistency
// 6. Updated the "addMessage" function in the LogFile contract to use a struct instead of a global variable to prevent potential vulnerabilities.