pragma solidity ^0.8.0;

contract Private_Bank {
    mapping (address => uint) public balances;
    
    uint public MinDeposit = 1 ether;
    
    Log TransferLog;
    
    constructor(address _log) {
        TransferLog = new Log(_log);
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
        (bool success, ) = msg.sender.call{value: _am}("");
        require(success, "Transfer failed");
    }
    
    function() external payable {}    
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
        History.push(Message({
            Sender: _adr,
            Time: block.timestamp,
            Val: _val,
            Data: _data
        }));
    }
} 

// Changes Made:
// 1. Updated the pragma version to ^0.8.0
// 2. Added constructor keyword to the constructor function
// 3. Added require statements for input validations
// 4. Moved the balance update before the external call to prevent re-entrancy
// 5. Replaced the deprecated call() function with the new syntax for external calls
// 6. Modified the Log contract to store Message struct directly instead of reusing a variable.