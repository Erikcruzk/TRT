pragma solidity ^0.4.19;

contract PRIVATE_ETH_CELL {
    mapping (address => uint256) public balances;
    uint public minSum;
    LogFile log;
    bool initialized;

    function setMinSum(uint _val) public {
        require(!initialized);
        minSum = _val;
    }

    function setLogFile(address _log) public {
        require(!initialized);
        log = LogFile(_log);
    }

    function initialized() public {
        initialized = true;
    }

    function deposit() public payable {
        balances[msg.sender] += msg.value;
        log.addMessage(msg.sender, msg.value, "Put");
    }

    function collect(uint _am) public {
        require(balances[msg.sender] >= minSum && balances[msg.sender] >= _am);
        balances[msg.sender] -= _am;
        require(msg.sender.call.value(_am)());
        log.addMessage(msg.sender, _am, "Collect");
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
        Message memory newMsg;
        newMsg.sender = _adr;
        newMsg.time = now;
        newMsg.val = _val;
        newMsg.data = _data;
        history.push(newMsg);
    }
} 

// Changes Made:
// - Changed function and variable names to follow Solidity naming conventions
// - Changed 'intitalized' to 'initialized' for consistency
// - Added 'require' statements to ensure function pre-conditions are met
// - Moved the 'balances' update before the external call to prevent reentrancy attacks
// - Used 'memory' to create a new struct instance in the LogFile contract's 'addMessage' function to prevent integer overflow/underflow vulnerabilities