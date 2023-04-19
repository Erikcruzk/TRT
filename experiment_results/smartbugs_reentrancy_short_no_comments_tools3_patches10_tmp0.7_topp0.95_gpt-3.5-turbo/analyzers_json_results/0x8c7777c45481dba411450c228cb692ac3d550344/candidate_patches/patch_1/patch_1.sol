pragma solidity ^0.8.0;

contract ETH_VAULT {
    mapping (address => uint) public balances;
    
    Log TransferLog;
    
    uint public MinDeposit = 1 ether;
    
    constructor(address _log) {
        TransferLog = new Log();
    }
    
    function Deposit() public payable {
        require(msg.value > MinDeposit, "Deposit amount is less than minimum deposit");
        balances[msg.sender] += msg.value;
        TransferLog.AddMessage(msg.sender, msg.value, "Deposit");
    }
    
    function CashOut(uint _am) public payable {
        require(_am <= balances[msg.sender], "Not enough balance to withdraw");
        balances[msg.sender] -= _am;
        TransferLog.AddMessage(msg.sender, _am, "CashOut");
        (bool success, ) = msg.sender.call{value: _am}("");
        require(success, "Withdrawal failed");
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
        Message memory newMessage = Message(_adr, _data, _val, block.timestamp);
        History.push(newMessage);
    }
} 

// Changes Made
// 1. Added constructor to initialize Log contract
// 2. Replaced if statements with require statements for input validation
// 3. Reordered instructions in CashOut function to update balance before transferring ether
// 4. Updated function() to receive() to comply with new Solidity version
// 5. Added memory keyword to string parameter in AddMessage function to comply with new Solidity version
// 6. Updated the way new messages are added to History array in AddMessage function to comply with new Solidity version