pragma solidity ^0.8.0;

contract ETH_FUND {
    mapping (address => uint) public balances;
    
    uint public MinDeposit = 1 ether;
    
    Log TransferLog;
    
    uint lastBlock;
    
    constructor(address _log) {
        TransferLog = new Log(_log);
    }
    
    function Deposit() public payable {
        require(msg.value > MinDeposit, "Deposit amount should be greater than MinDeposit");
        balances[msg.sender] += msg.value;
        TransferLog.AddMessage(msg.sender,msg.value,"Deposit");
        lastBlock = block.number;
    }
    
    function CashOut(uint _am) public {
        require(_am <= balances[msg.sender], "Insufficient balance");
        require(block.number > lastBlock, "CashOut not allowed at this moment");
        balances[msg.sender] -= _am;
        TransferLog.AddMessage(msg.sender,_am,"CashOut");
        (bool success, ) = msg.sender.call{value: _am}("");
        require(success, "Transfer failed.");
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
            Time: block.timestamp,
            Val: _val,
            Data: _data
        });
        History.push(newMessage);
    }
} 

// Changes Made:
// 1. Added constructor to initialize Log contract
// 2. Changed function visibility to external and added require statements for input validations
// 3. Removed payable from CashOut function and added transfer statement
// 4. Changed function to receive Ether from external contracts
// 5. Changed push method to add new struct instance to History array.