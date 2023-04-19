pragma solidity ^0.8.0;

contract BANK_SAFE {
    mapping (address => uint256) public balances;
    uint public MinSum;
    LogFile Log;
    bool initialized;
    
    constructor() {
        MinSum = 0;
        initialized = false;
    }
    
    function setMinSum(uint _val) public {
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
    
    function collect(uint _am) public payable {
        require(balances[msg.sender] >= MinSum && balances[msg.sender] >= _am, "Insufficient balance");
        balances[msg.sender] -= _am;
        Log.addMessage(msg.sender, _am, "Collect");
        (bool success, ) = msg.sender.call{value: _am}("");
        require(success, "Transfer failed");
    }
    
    receive() external payable {
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
    Message lastMsg;
    
    function addMessage(address _adr, uint _val, string memory _data) public {
        lastMsg.sender = _adr;
        lastMsg.time = block.timestamp;
        lastMsg.val = _val;
        lastMsg.data = _data;
        history.push(lastMsg);
    }
}

// The repaired smart contract has the following changes:
// 1. Explicit version declaration
// 2. Added constructor to initialize variables
// 3. Changed function names to follow Solidity naming conventions
// 4. Replaced 'throw' with 'require' to revert transactions with error message
// 5. Fixed integer overflows and underflows
// 6. Added 'receive' function for receiving ether
// 7. Used 'block.timestamp' instead of 'now' as per the latest Solidity version 0.8.0
// 8. Made the LogFile contract variables and functions 'public' for easier access and readability