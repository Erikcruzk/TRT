pragma solidity ^0.8.0;

contract PrivateBank {
    mapping (address => uint) public balances;
        
    uint public MinDeposit = 1 ether;
    
    Log TransferLog;
    
    constructor(address _lib) {
        TransferLog = new Log();
    }
    
    function Deposit() public payable {
        require(msg.value >= MinDeposit, "Deposit amount should be greater than or equal to MinDeposit");
        balances[msg.sender] += msg.value;
        TransferLog.AddMessage(msg.sender, msg.value, "Deposit");
    }
    
    function CashOut(uint _am) public {
        require(_am <= balances[msg.sender], "Amount should be less than or equal to balance");
        balances[msg.sender] -= _am;
        TransferLog.AddMessage(msg.sender, _am, "CashOut");
        (bool success, ) = msg.sender.call{value: _am}("");
        require(success, "Transfer failed.");
    }
    
    receive() external payable {}    
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
        Message memory newMsg = Message({
            Sender: _adr,
            Time: block.timestamp,
            Val: _val,
            Data: _data
        });
        History.push(newMsg);
    }
} 

// The repaired contract includes the following changes:
// 1. Added constructor keyword to the constructor function
// 2. Replaced the Log contract address with a new Log instance
// 3. Added require statements to ensure valid inputs and prevent integer overflows/underflows
// 4. Moved the balance update before the external call to prevent reentrancy attacks
// 5. Changed the LastMsg struct to a local variable in AddMessage function to prevent overwriting of data.