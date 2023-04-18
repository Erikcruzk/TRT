pragma solidity ^0.8.0;

contract ETH_VAULT {
    mapping (address => uint) public balances;
    
    Log TransferLog;
    
    uint public MinDeposit = 1 ether;
    
    constructor(address _log) {
        TransferLog = new Log();
        TransferLog.setOwner(msg.sender);
    }
    
    function Deposit() public payable {
        require(msg.value > MinDeposit, "Minimum deposit not met");
        balances[msg.sender] += msg.value;
        TransferLog.AddMessage(msg.sender,msg.value,"Deposit");
    }
    
    function CashOut(uint _am) public payable {
        require(_am <= balances[msg.sender], "Insufficient balance");
        balances[msg.sender] -= _am;
        TransferLog.AddMessage(msg.sender,_am,"CashOut");
        (bool success, ) = msg.sender.call{value: _am}("");
        require(success, "Transfer failed");
    }
    
    function() external payable {}    
}

contract Log {
    address public owner;
   
    struct Message {
        address Sender;
        string  Data;
        uint Val;
        uint  Time;
    }
    
    Message[] public History;
    
    Message LastMsg;
    
    constructor() {}
    
    function setOwner(address _owner) public {
        require(owner == address(0), "Owner already set");
        owner = _owner;
    }
    
    function AddMessage(address _adr, uint _val, string memory _data) public {
        require(msg.sender == owner, "Only owner can add messages");
        LastMsg.Sender = _adr;
        LastMsg.Time = block.timestamp;
        LastMsg.Val = _val;
        LastMsg.Data = _data;
        History.push(LastMsg);
    }
} 

// Changes made:
// 1. Added constructor to initialize TransferLog
// 2. Changed function visibility to external for fallback function
// 3. Added require statements to check for minimum deposit and sufficient balance
// 4. Moved balance subtraction before external call to prevent reentrancy
// 5. Added owner variable to Log contract and setOwner function to set the owner
// 6. Added require statement to AddMessage function to ensure only owner can add messages
// 7. Changed string parameter to memory to comply with new Solidity version.