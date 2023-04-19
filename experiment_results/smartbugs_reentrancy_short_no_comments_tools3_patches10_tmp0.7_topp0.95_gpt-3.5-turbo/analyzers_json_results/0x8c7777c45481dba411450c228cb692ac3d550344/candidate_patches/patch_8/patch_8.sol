pragma solidity ^0.8.0;

contract ETH_VAULT {
    mapping (address => uint) public balances;
    
    Log TransferLog;
    
    uint public MinDeposit = 1 ether;
    
    constructor(address _log) {
        TransferLog = new Log();
    }
    
    function Deposit() public payable {
        require(msg.value > MinDeposit, "Deposit amount must be greater than minimum deposit.");
        balances[msg.sender] += msg.value;
        TransferLog.AddMessage(msg.sender, msg.value, "Deposit");
    }
    
    function CashOut(uint _am) public payable {
        require(_am <= balances[msg.sender], "Insufficient balance.");
        balances[msg.sender] -= _am;
        require(msg.sender.call{value: _am}(), "Transaction failed.");
        TransferLog.AddMessage(msg.sender, _am, "CashOut");
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
        Message memory newMessage = Message({
            Sender: _adr,
            Val: _val,
            Data: _data,
            Time: block.timestamp
        });
        History.push(newMessage);
    }
}

// Fixed issues:
// - Updated Solidity version to ^0.8.0
// - Added constructor function to initialize TransferLog
// - Added require statements to check for minimum deposit and sufficient balance
// - Removed reentrancy vulnerability by updating balance before external call
// - Updated LastMsg struct to newMessage struct in Log contract
// - Added memory keyword to string parameters in AddMessage function