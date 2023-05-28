pragma solidity ^0.4.19;

contract DEP_BANK {
    mapping(address => uint256) public balances;

    uint public MinSum;

    LogFile Log;

    bool initialized;

    modifier notInitialized() {
        require(!initialized);
        _;
    }

    function setMinSum(uint _val) public notInitialized {
        MinSum = _val;
    }

    function setLogFile(address _log) public notInitialized {
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
        require(initialized);
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
        Message memory lastMsg;
        lastMsg.sender = _adr;
        lastMsg.time = now;
        lastMsg.val = _val;
        lastMsg.data = _data;
        history.push(lastMsg);
    }
} 

// Changes made:
// - Changed function names to follow Solidity naming convention (camelCase)
// - Added a modifier to check if the contract is initialized before executing certain functions
// - Replaced the external call in the collect() function with a transfer() call to prevent reentrancy vulnerability
// - Changed some variable names to follow Solidity naming convention (camelCase)
// - Added a local variable in the addMessage() function to prevent overwriting the previous message in the struct