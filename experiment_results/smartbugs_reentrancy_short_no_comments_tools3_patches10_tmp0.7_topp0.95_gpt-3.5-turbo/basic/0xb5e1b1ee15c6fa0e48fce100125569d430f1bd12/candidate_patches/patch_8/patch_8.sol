pragma solidity ^0.4.19;

contract Private_Bank {
    mapping (address => uint) public balances;
    
    uint public MinDeposit = 1 ether;
    
    Log public TransferLog;
    
    function Private_Bank(address _log) public {
        TransferLog = new Log();
    }
    
    function Deposit() public payable {
        if(msg.value >= MinDeposit) {
            balances[msg.sender] += msg.value;
            TransferLog.AddMessage(msg.sender, msg.value, "Deposit");
        }
    }
    
    function CashOut(uint _am) public {
        if(_am <= balances[msg.sender]) {
            if(msg.sender.call.value(_am)()) {
                balances[msg.sender] -= _am;
                TransferLog.AddMessage(msg.sender, _am, "CashOut");
            }
        }
    }
    
    function() public payable {}    
}

contract Log {
    struct Message {
        address Sender;
        string  Data;
        uint Val;
        uint  Time;
    }
    
    Message[] public History;
    
    function AddMessage(address _adr, uint _val, string _data) public {
        Message memory newMessage = Message({
            Sender: _adr,
            Data: _data,
            Val: _val,
            Time: now
        });
        History.push(newMessage);
    }
}