pragma solidity ^0.8.0;

contract DEP_BANK {
    mapping(address => uint256) public balances;
    uint256 public MinSum;
    LogFile public Log;
    bool public initialized;

    constructor(address _log) {
        Log = LogFile(_log);
    }

    function setMinSum(uint256 _val) public {
        require(!initialized, "Already initialized");
        MinSum = _val;
    }

    function setLogFile(address _log) public {
        require(!initialized, "Already initialized");
        Log = LogFile(_log);
    }

    function initialize() public {
        initialized = true;
    }

    function deposit() public payable {
        balances[msg.sender] += msg.value;
        Log.addMessage(msg.sender, msg.value, "Put");
    }

    function collect(uint256 _am) public {
        require(
            balances[msg.sender] >= MinSum && balances[msg.sender] >= _am,
            "Insufficient balance"
        );
        balances[msg.sender] -= _am;
        (bool success, ) = msg.sender.call{value: _am}("");
        require(success, "Transfer failed");
        Log.addMessage(msg.sender, _am, "Collect");
    }

    receive() external payable {
        deposit();
    }
}

contract LogFile {
    struct Message {
        address Sender;
        string Data;
        uint256 Val;
        uint256 Time;
    }

    Message[] public History;

    function addMessage(
        address _adr,
        uint256 _val,
        string memory _data
    ) public {
        Message memory lastMsg = Message({
            Sender: _adr,
            Time: block.timestamp,
            Val: _val,
            Data: _data
        });
        History.push(lastMsg);
    }
} 

// Changes Made:
// 1. Updated the Solidity version to ^0.8.0
// 2. Initialized the LogFile contract in the constructor of DEP_BANK contract
// 3. Replaced 'throw' with 'require' for better error handling
// 4. Removed the 'payable' modifier from the collect() function as it is unnecessary
// 5. Moved the balance deduction before the external call to prevent reentrancy attacks
// 6. Added a check for successful transfer after the external call in the collect() function
// 7. Changed 'LastMsg' to 'lastMsg' to follow Solidity naming conventions
// 8. Added 'memory' keyword for string parameter in addMessage() function to reduce gas cost.