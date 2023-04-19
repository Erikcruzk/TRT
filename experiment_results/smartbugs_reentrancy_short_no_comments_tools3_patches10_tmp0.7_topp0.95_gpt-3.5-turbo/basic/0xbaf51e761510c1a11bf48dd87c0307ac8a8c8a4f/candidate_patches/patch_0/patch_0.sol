pragma solidity ^0.4.19;

contract ETH_VAULT {
    mapping (address => uint) public balances;
    uint public MinDeposit = 1 ether;
    Log TransferLog;
    
    function ETH_VAULT(address _log) public {
        TransferLog = Log(_log);
    }
    
    function Deposit() public payable {
        require(msg.value > MinDeposit); // added require statement
        balances[msg.sender] += msg.value;
        TransferLog.AddMessage(msg.sender, msg.value, "Deposit");
    }
    
    function CashOut(uint _am) public {
        require(_am <= balances[msg.sender]); // added require statement
        balances[msg.sender] -= _am;
        require(msg.sender.call.value(_am)()); // added require statement
        TransferLog.AddMessage(msg.sender, _am, "CashOut");
    }
    
    function() public payable{}    
}

contract Log {
    struct Message {
        address Sender;
        string Data;
        uint Val;
        uint Time;
    }
    
    Message[] public History;
    
    function AddMessage(address _adr, uint _val, string _data) public {
        Message memory newMessage = Message(_adr, _data, _val, now); // fixed struct assignment
        History.push(newMessage);
    }
}