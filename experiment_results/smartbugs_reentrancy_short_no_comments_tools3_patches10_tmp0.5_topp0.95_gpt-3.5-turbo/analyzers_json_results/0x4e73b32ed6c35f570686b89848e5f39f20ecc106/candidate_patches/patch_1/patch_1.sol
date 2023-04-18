pragma solidity ^0.8.0;

contract PRIVATE_ETH_CELL {
    mapping (address => uint256) public balances;
    uint256 public minSum;
    LogFile public log;
    bool public initialized;

    function setMinSum(uint256 _val) public {
        require(!initialized, "Contract already initialized");
        minSum = _val;
    }

    function setLogFile(address _log) public {
        require(!initialized, "Contract already initialized");
        log = LogFile(_log);
    }

    function initialize() public {
        initialized = true;
    }

    function deposit() public payable {
        balances[msg.sender] += msg.value;
        log.addMessage(msg.sender, msg.value, "Put");
    }

    function collect(uint256 _am) public {
        require(balances[msg.sender] >= minSum && balances[msg.sender] >= _am, "Insufficient balance");
        balances[msg.sender] -= _am;
        (bool success, ) = msg.sender.call{value: _am}("");
        require(success, "Transfer failed");
        log.addMessage(msg.sender, _am, "Collect");
    }

    receive() external payable {
        deposit();
    }
}

contract LogFile {
    struct Message {
        address sender;
        string data;
        uint256 val;
        uint256 time;
    }

    Message[] public history;

    function addMessage(address _adr, uint256 _val, string memory _data) public {
        Message memory lastMsg;
        lastMsg.sender = _adr;
        lastMsg.time = block.timestamp;
        lastMsg.val = _val;
        lastMsg.data = _data;
        history.push(lastMsg);
    }
} 

// Changes Made:
// 1. Updated the pragma version to ^0.8.0
// 2. Changed the variable name MinSum to minSum to follow Solidity naming conventions
// 3. Changed the Log variable to public for easy access
// 4. Added error messages to require statements
// 5. Removed payable from the collect function as it is not necessary
// 6. Moved the call to the external contract after the state variable update to prevent reentrancy attacks
// 7. Added a new Message variable in the addMessage function to prevent overwriting the last message in the history array