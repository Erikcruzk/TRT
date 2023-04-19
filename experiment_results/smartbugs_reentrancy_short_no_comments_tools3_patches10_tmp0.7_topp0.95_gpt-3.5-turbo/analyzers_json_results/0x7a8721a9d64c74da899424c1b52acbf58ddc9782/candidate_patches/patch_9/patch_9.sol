pragma solidity ^0.8.0;

contract PrivateDeposit {
    mapping (address => uint) public balances;
        
    uint public minDeposit = 1 ether;
    address public owner;
    
    Log transferLog;
    
    modifier onlyOwner() {
        require(msg.sender == owner, "Only contract owner can call this function");
        _;
    }    
    
    constructor() {
        owner = msg.sender;
        transferLog = new Log();
    }
    
    function setLog(address _lib) external onlyOwner {
        transferLog = Log(_lib);
    }    
    
    function deposit() public payable {
        require(msg.value >= minDeposit, "Minimum deposit not met");
        
        balances[msg.sender] += msg.value;
        transferLog.addMessage(msg.sender, msg.value, "Deposit");
    }
    
    function cashOut(uint _am) public {
        require(_am <= balances[msg.sender], "Not enough balance to cash out");
        
        balances[msg.sender] -= _am;
        transferLog.addMessage(msg.sender, _am, "CashOut");
        
        (bool success, ) = msg.sender.call{value: _am}("");
        require(success, "Transfer failed");
    }
    
    fallback() external payable {}    
    
}

contract Log {
    struct Message {
        address sender;
        string  data;
        uint val;
        uint  time;
    }
    
    Message[] public history;
    
    function addMessage(address _adr, uint _val, string memory _data) public {
        Message memory newMessage = Message({
            sender: _adr,
            time: block.timestamp,
            val: _val,
            data: _data
        });
        history.push(newMessage);
    }
} 

// The repaired contract includes the following changes:
// - Updated the Solidity version to ^0.8.0
// - Changed function names to lowercase and updated variable names to follow Solidity naming conventions
// - Added require statements to check for minimum deposit and available balance before making transactions
// - Added a fallback function to receive ether transfers
// - Changed the addMessage function in the Log contract to create a new Message struct and push it to the history array