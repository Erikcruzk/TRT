pragma solidity ^0.5.16;

contract BankSafe {
    mapping (address => uint256) public balances;
    uint256 public minSum;
    LogFile public log;
    bool public initialized;

    function setMinSum(uint256 _val) public {
        require(!initialized, "Already initialized");
        minSum = _val;
    }

    function setLogFile(address _log) public {
        require(!initialized, "Already initialized");
        log = LogFile(_log);
    }

    function initialize() public {
        initialized = true;
    }

    function deposit() public payable {
        balances[msg.sender] += msg.value;
        log.addMessage(msg.sender, msg.value, "Deposit");
    }

    function collect(uint256 _am) public {
        require(balances[msg.sender] >= minSum && balances[msg.sender] >= _am, "Insufficient balance");
        balances[msg.sender] -= _am;
        (bool success, ) = msg.sender.call.value(_am)("");
        require(success, "Transfer failed");
        log.addMessage(msg.sender, _am, "Collect");
    }

    function() external payable {
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
        Message memory newMsg = Message({
            sender: _adr,
            time: now,
            val: _val,
            data: _data
        });
        history.push(newMsg);
    }
} 

// The repaired contract includes the following changes:
// - Updated pragma version to ^0.5.16
// - Renamed functions and variables to follow Solidity naming conventions
// - Replaced throw statements with require statements
// - Added error messages to require statements
// - Moved the state variable 'initialized' to the beginning of the contract for better readability
// - Fixed the reentrancy vulnerability by moving the balance update before the external call in the 'collect' function
// - Updated the 'collect' function to use the new Solidity syntax for external calls
// - Changed the 'LogFile' contract to use the memory keyword for the struct variable 'newMsg' in the 'addMessage' function