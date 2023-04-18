pragma solidity ^0.8.0;

contract DEP_BANK {
    mapping (address => uint256) public balances;   
   
    uint256 public minSum;
    
    LogFile public log;
    
    bool public initialized;
    
    constructor() {
        initialized = false;
    }
    
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
        Message memory newMsg = Message({
            sender: _adr,
            time: block.timestamp,
            val: _val,
            data: _data
        });
        history.push(newMsg);
    }
} 

// Changes Made:
// 1. Changed the pragma version to ^0.8.0
// 2. Changed the variable names to follow Solidity naming conventions
// 3. Added a constructor to initialize the 'initialized' variable
// 4. Changed the 'Initialized' function to 'initialize' and made it public
// 5. Changed the 'Deposit' function to 'deposit' and removed the 'payable' modifier from the 'Collect' function
// 6. Added 'require' statements to check for conditions and 'success' variable to check for successful transfers in the 'Collect' function
// 7. Changed the 'LogFile' contract to use 'memory' instead of 'storage' for the 'newMsg' variable in the 'addMessage' function.