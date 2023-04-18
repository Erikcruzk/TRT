pragma solidity ^0.8.0;

contract BANK_SAFE {
    mapping (address => uint256) public balances;
    uint256 public minSum;
    LogFile public log;
    bool public initialized;

    function setMinSum(uint256 _val) public {
        require(!initialized, "Already initialized");
        minSum = _val;
    }

    function setLogFile(LogFile _log) public {
        require(!initialized, "Already initialized");
        log = _log;
    }

    function initialize() public {
        initialized = true;
    }

    function deposit() public payable {
        balances[msg.sender] += msg.value;
        log.addMessage(msg.sender, msg.value, "Put");
    }

    function collect(uint256 _am) public {
        require(balances[msg.sender] >= minSum, "Balance is less than minimum sum");
        require(balances[msg.sender] >= _am, "Balance is less than amount to collect");

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
        history.push(Message({
            sender: _adr,
            time: block.timestamp,
            val: _val,
            data: _data
        }));
    }
} 

// Changes Made:
// 1. Updated the Solidity version to ^0.8.0.
// 2. Changed the name of the "MinSum" variable to "minSum" to follow Solidity naming conventions.
// 3. Added "require" statements to validate the inputs and avoid integer overflow/underflow vulnerabilities.
// 4. Moved the transfer of funds before the log message to prevent reentrancy attacks.
// 5. Changed the "Initialized" function to "initialize" to follow Solidity naming conventions.
// 6. Updated the "LogFile" contract to use "memory" instead of "storage" for the string parameter in the "addMessage" function to reduce gas costs.