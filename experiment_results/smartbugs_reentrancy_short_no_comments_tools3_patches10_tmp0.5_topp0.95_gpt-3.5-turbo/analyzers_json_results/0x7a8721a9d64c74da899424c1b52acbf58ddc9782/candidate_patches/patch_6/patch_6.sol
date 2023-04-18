pragma solidity ^0.8.0;

contract PrivateDeposit {
    mapping (address => uint256) public balances;
        
    uint256 public MinDeposit = 1 ether;
    address public owner;
    
    Log TransferLog;
    
    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function");
        _;
    }    
    
    constructor() {
        owner = msg.sender;
        TransferLog = new Log();
    }
    
    function setLog(address _lib) public onlyOwner {
        TransferLog = Log(_lib);
    }    
    
    function deposit() public payable {
        require(msg.value >= MinDeposit, "Deposit amount should be greater than or equal to MinDeposit");
        balances[msg.sender] += msg.value;
        TransferLog.addMessage(msg.sender, msg.value, "Deposit");
    }
    
    function cashOut(uint256 _am) public {
        require(_am <= balances[msg.sender], "Insufficient balance");
        balances[msg.sender] -= _am;
        TransferLog.addMessage(msg.sender, _am, "CashOut");
        (bool success, ) = msg.sender.call{value: _am}("");
        require(success, "Transfer failed.");
    }
    
    receive() external payable {}    
}

contract Log {
    struct Message {
        address Sender;
        string Data;
        uint256 Val;
        uint256 Time;
    }
    
    Message[] public History;
    
    function addMessage(address _adr, uint256 _val, string memory _data) public {
        Message memory lastMsg;
        lastMsg.Sender = _adr;
        lastMsg.Time = block.timestamp;
        lastMsg.Val = _val;
        lastMsg.Data = _data;
        History.push(lastMsg);
    }
} 

// Changes Made:
// 1. Updated the pragma version to 0.8.0
// 2. Changed function names to follow the Solidity naming convention
// 3. Added error messages to require statements
// 4. Added a receive function to receive ether
// 5. Fixed the reentrancy vulnerability by transferring ether before updating the balances[msg.sender] state variable
// 6. Added a new Message memory variable to avoid overwriting the previous message in the History array.