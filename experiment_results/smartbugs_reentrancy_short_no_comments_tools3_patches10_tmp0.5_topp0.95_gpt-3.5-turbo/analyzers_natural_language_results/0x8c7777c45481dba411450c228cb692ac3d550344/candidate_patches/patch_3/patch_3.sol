pragma solidity ^0.8.0;

contract ETH_VAULT {
    mapping (address => uint) public balances;
    
    Log TransferLog;
    
    uint public MinDeposit = 1 ether;
    
    constructor(address _log) {
        TransferLog = new Log();
    }
    
    function Deposit() public payable {
        require(msg.value > MinDeposit, "Deposit amount must be greater than minimum deposit");
        balances[msg.sender] += msg.value;
        TransferLog.AddMessage(msg.sender, msg.value, "Deposit");
    }
    
    function CashOut(uint _am) public payable {
        require(_am <= balances[msg.sender], "Insufficient balance");
        balances[msg.sender] -= _am;
        require(msg.sender.call{value: _am}(), "Transfer failed");
        TransferLog.AddMessage(msg.sender, _am, "CashOut");
    }
    
    fallback() external payable {}
}

contract Log {
    struct Message {
        address Sender;
        string Data;
        uint Val;
        uint Time;
    }
    
    Message[] public History;
    
    function AddMessage(address _adr, uint _val, string memory _data) public {
        Message memory newMessage = Message({
            Sender: _adr,
            Time: block.timestamp,
            Val: _val,
            Data: _data
        });
        History.push(newMessage);
    }
}

// Changes made:
// - Added constructor to initialize TransferLog
// - Replaced if statement with require statement in Deposit function
// - Reordered statements in CashOut function to prevent reentrancy vulnerability
// - Replaced fallback function with fallback() external payable {} to comply with new Solidity versions
// - Added memory keyword to string parameter in AddMessage function
// - Used struct literal to create newMessage in AddMessage function