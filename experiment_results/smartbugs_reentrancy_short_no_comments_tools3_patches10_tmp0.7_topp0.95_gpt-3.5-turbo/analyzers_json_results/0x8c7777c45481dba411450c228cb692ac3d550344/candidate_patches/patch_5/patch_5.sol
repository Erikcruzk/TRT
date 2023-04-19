pragma solidity ^0.8.0;

contract ETH_VAULT {
    mapping (address => uint) public balances;
    
    Log TransferLog;
    
    uint public MinDeposit = 1 ether;
    
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
        bool success = payable(msg.sender).send(_am);
        require(success, "Failed to transfer funds");
        TransferLog.AddMessage(msg.sender, _am, "CashOut");
    }
    
    function getBalance() public view returns (uint) {
        return balances[msg.sender];
    }
    
    receive() external payable {}
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
        Message memory newMessage = Message(_adr, _data, _val, block.timestamp);
        History.push(newMessage);
    }
} 

// Changes Made:
// 1. Updated the pragma version to ^0.8.0
// 2. Added a constructor to initialize the TransferLog contract
// 3. Replaced if statements with require statements to handle errors
// 4. Added a getBalance function to check the balance of the user
// 5. Replaced the call function with send to prevent reentrancy attack
// 6. Removed the LastMsg variable and used a memory variable to create a new message in the AddMessage function.