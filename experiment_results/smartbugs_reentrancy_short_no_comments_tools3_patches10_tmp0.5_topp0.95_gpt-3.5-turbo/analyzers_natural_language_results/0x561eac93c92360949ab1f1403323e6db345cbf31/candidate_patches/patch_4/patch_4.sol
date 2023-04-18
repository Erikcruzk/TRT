pragma solidity ^0.8.0;

contract BANK_SAFE {
    mapping(address => uint256) public balances;
    uint256 public minSum;
    LogFile public log;
    bool public initialized;

    constructor() {
        minSum = 0;
        initialized = false;
    }

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

    function addMessage(
        address _adr,
        uint256 _val,
        string memory _data
    ) public {
        Message memory lastMsg = Message({
            sender: _adr,
            time: block.timestamp,
            val: _val,
            data: _data
        });
        history.push(lastMsg);
    }
} 

// Changes made:
// 1. Updated pragma version to ^0.8.0
// 2. Added constructor to initialize variables
// 3. Replaced "throw" with "require" for better error handling
// 4. Removed "payable" from collect function as it does not require any ether
// 5. Moved balance deduction before the external call to prevent reentrancy attacks
// 6. Added "require" statements for better validation
// 7. Changed "now" to "block.timestamp" for better security
// 8. Renamed Log to log for consistency and to follow Solidity naming conventions.