pragma solidity ^0.8.0;

contract BANK_SAFE {
    mapping (address => uint256) public balances;   
    uint public MinSum;
    LogFile Log;
    bool initialized;
    
    constructor() {
        initialized = false;
    }
    
    function setMinSum(uint _val) public {
        require(!initialized, "Contract already initialized");
        MinSum = _val;
    }
    
    function setLogFile(address _log) public {
        require(!initialized, "Contract already initialized");
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
        require(balances[msg.sender] >= MinSum && balances[msg.sender] >= _am, "Insufficient balance");
        balances[msg.sender] -= _am;
        require(payable(msg.sender).send(_am), "Transaction failed");
        Log.addMessage(msg.sender, _am, "Collect");
    }
    
    function() external payable {
        deposit();
    }
}

contract LogFile {
    struct Message {
        address Sender;
        string Data;
        uint Val;
        uint Time;
    }
    
    Message[] public History;
    
    function addMessage(address _adr, uint _val, string memory _data) public {
        Message memory newMessage = Message({
            Sender: _adr,
            Data: _data,
            Val: _val,
            Time: block.timestamp
        });
        History.push(newMessage);
    }
}

// Changes made:
// 1. Updated pragma version to ^0.8.0
// 2. Added constructor to initialize initialized variable
// 3. Replaced intitalized with initialized for consistency
// 4. Changed function names to follow Solidity naming conventions
// 5. Replaced throw with require for better error handling
// 6. Removed payable modifier from collect function
// 7. Reordered code for better readability
// 8. Added require statements for input validation
// 9. Added payable modifier and require statement for send function in collect function
// 10. Changed addMessage function to use struct memory instead of storage for gas optimization
// 11. Changed Time variable to use block.timestamp instead of now for consistency and future-proofing.