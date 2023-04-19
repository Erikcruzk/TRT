pragma solidity ^0.8.0;

contract Private_Bank {
    mapping (address => uint256) public balances;
    
    uint256 public MinDeposit = 1 ether;
    
    Log TransferLog;
    
    constructor(address _log) {
        TransferLog = new Log(_log);
    }
    
    function Deposit() public payable {
        require(msg.value > MinDeposit, "Deposit amount should be greater than MinDeposit");
        balances[msg.sender] += msg.value;
        TransferLog.AddMessage(msg.sender, msg.value, "Deposit");
    }
    
    function CashOut(uint256 _am) public {
        require(_am <= balances[msg.sender], "Insufficient balance");
        balances[msg.sender] -= _am;
        (bool success, ) = msg.sender.call{value: _am}("");
        require(success, "Transfer failed.");
        TransferLog.AddMessage(msg.sender, _am, "CashOut");
    }
    
    receive() external payable {}
}

contract Log {
    struct Message {
        address Sender;
        string Data;
        uint256 Val;
        uint256 Time;
    }
    
    Message[] public History;
    
    function AddMessage(address _adr, uint256 _val, string memory _data) public {
        Message memory lastMsg = Message(_adr, _data, _val, block.timestamp);
        History.push(lastMsg);
    }
} 

// Changes Made:
// 1. Added constructor for Log contract instance creation
// 2. Replaced if statement with require for Deposit function
// 3. Removed payable modifier from CashOut function
// 4. Changed balances[msg.sender]-=_am to balances[msg.sender] -= _am
// 5. Added receive function for contract to receive ether.