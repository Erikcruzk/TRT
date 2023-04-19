pragma solidity ^0.8.0;

contract MONEY_BOX {
    struct Holder {
        uint unlockTime;
        uint balance;
    }
    
    mapping (address => Holder) public Acc;
    
    uint public MinSum;
    
    Log LogFile;
    
    bool initialized;
    
    constructor() {
        initialized = false;
    }
    
    function setMinSum(uint _val) public {
        require(!initialized, "Already initialized");
        MinSum = _val;
    }
    
    function setLogFile(address _log) public {
        require(!initialized, "Already initialized");
        LogFile = Log(_log);
    }
    
    function initialize() public {
        initialized = true;
    }
    
    function put(uint _lockTime) public payable {
        Holder storage acc = Acc[msg.sender];
        acc.balance += msg.value;
        if(block.timestamp + _lockTime > acc.unlockTime) {
            acc.unlockTime = block.timestamp + _lockTime;
        }
        LogFile.addMessage(msg.sender, msg.value, "Put");
    }
    
    function collect(uint _am) public payable {
        Holder storage acc = Acc[msg.sender];
        require(acc.balance >= MinSum && acc.balance >= _am && block.timestamp > acc.unlockTime, "Invalid balance or unlock time");
        acc.balance -= _am;
        (bool success, ) = msg.sender.call{value: _am}("");
        require(success, "Transaction failed");
        LogFile.addMessage(msg.sender, _am, "Collect");
    }
    
    receive() external payable {
        put(0);
    }
    
}


contract Log {
    struct Message {
        address Sender;
        string Data;
        uint Val;
        uint Time;
    }
    
    Message[] public History;
    
    function addMessage(address _adr, uint _val, string memory _data) public {
        Message memory lastMsg;
        lastMsg.Sender = _adr;
        lastMsg.Time = block.timestamp;
        lastMsg.Val = _val;
        lastMsg.Data = _data;
        History.push(lastMsg);
    }
} 

// Changes Made:
// 1. Updated the Solidity version to 0.8.0
// 2. Added constructor to initialize the bool variable to false
// 3. Replaced "throw" with "require" for better error handling
// 4. Replaced "now" with "block.timestamp" for better security
// 5. Added "storage" keyword to the Holder struct in the put() and collect() functions
// 6. Reordered the code to follow best practices
// 7. Added error handling to the collect() function
// 8. Added "memory" keyword to the addMessage() function in the Log contract
// 9. Initialized the LastMsg variable in the Log contract inside the function to avoid reusing the same struct instance.