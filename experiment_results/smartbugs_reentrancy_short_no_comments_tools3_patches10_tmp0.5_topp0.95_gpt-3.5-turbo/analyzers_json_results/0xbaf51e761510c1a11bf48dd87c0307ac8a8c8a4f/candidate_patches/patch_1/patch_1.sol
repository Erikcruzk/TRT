pragma solidity ^0.8.0;

contract ETH_VAULT {
    mapping (address => uint) public balances;
    
    uint public MinDeposit = 1 ether;
    
    Log TransferLog;
    
    constructor(address _log) {
        TransferLog = new Log();
    }
    
    function Deposit() public payable {
        require(msg.value > MinDeposit, "Deposit amount should be greater than MinDeposit");
        balances[msg.sender] += msg.value;
        TransferLog.AddMessage(msg.sender, msg.value, "Deposit");
    }
    
    function CashOut(uint _am) public {
        require(_am <= balances[msg.sender], "Insufficient balance");
        balances[msg.sender] -= _am;
        TransferLog.AddMessage(msg.sender, _am, "CashOut");
        payable(msg.sender).transfer(_am);
    }
    
    function() external payable {}
}

contract Log {
    struct Message {
        address Sender;
        string  Data;
        uint Val;
        uint  Time;
    }
    
    Message[] public History;
    
    function AddMessage(address _adr, uint _val, string memory _data) public {
        Message memory newMessage = Message({
            Sender: _adr,
            Data: _data,
            Val: _val,
            Time: block.timestamp
        });
        History.push(newMessage);
    }
} 

// Changes Made:
// 1. Added constructor to initialize the TransferLog.
// 2. Added require statements to check for valid conditions.
// 3. Removed payable from CashOut function to prevent re-entrancy attacks.
// 4. Used transfer() instead of call.value() to send funds to prevent re-entrancy attacks.
// 5. Changed function() to function() external payable {} to follow best practices. 
// 6. Added memory keyword to string parameter in AddMessage function. 
// 7. Added memory keyword to Message struct in AddMessage function.