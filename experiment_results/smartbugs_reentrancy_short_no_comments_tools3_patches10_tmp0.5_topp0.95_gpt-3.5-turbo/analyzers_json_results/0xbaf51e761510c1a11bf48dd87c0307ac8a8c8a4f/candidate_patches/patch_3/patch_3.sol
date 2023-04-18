pragma solidity ^0.8.0;

contract ETH_VAULT {
    mapping (address => uint) public balances;
    
    uint public MinDeposit = 1 ether;
    
    Log TransferLog;
    
    constructor(address _log) {
        TransferLog = new Log();
    }
    
    function Deposit() public payable {
        require(msg.value > MinDeposit, "Amount deposited must be greater than minimum deposit");
        balances[msg.sender] += msg.value;
        TransferLog.AddMessage(msg.sender, msg.value, "Deposit");
    }
    
    function CashOut(uint _am) public {
        require(_am <= balances[msg.sender], "Amount withdrawn must be less than or equal to balance");
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
        string Data;
        uint Val;
        uint Time;
    }
    
    Message[] public History;
    
    function AddMessage(address _adr, uint _val, string memory _data) public {
        Message memory newMsg = Message({
            Sender: _adr,
            Data: _data,
            Val: _val,
            Time: block.timestamp
        });
        History.push(newMsg);
    }
} 

// Changes Made:
// 1. Added constructor to initialize TransferLog
// 2. Replaced if statements with require statements for better readability and security
// 3. Removed payable keyword from CashOut function to prevent re-entrancy attack
// 4. Added receive function to receive ether
// 5. Modified AddMessage function to create a new Message struct instead of modifying LastMsg struct
// 6. Updated syntax to Solidity 0.8.0 version