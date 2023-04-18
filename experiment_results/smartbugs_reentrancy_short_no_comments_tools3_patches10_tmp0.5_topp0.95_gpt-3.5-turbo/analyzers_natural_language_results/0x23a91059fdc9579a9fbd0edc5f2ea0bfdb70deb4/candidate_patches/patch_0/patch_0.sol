pragma solidity ^0.4.19;

contract PrivateBank {
    mapping (address => uint) public balances;
    
    uint public MinDeposit = 1 ether;
    
    Log TransferLog;
    
    function PrivateBank(address _log) public {
        TransferLog = Log(_log);
    }
    
    function deposit() public payable {
        if(msg.value >= MinDeposit) {
            balances[msg.sender] += msg.value;
            TransferLog.addMessage(msg.sender, msg.value, "Deposit");
        }
    }
    
    function cashOut(uint _am) public {
        require(_am <= balances[msg.sender]); // check if the balance is sufficient
        
        balances[msg.sender] -= _am; // update the balance
        
        if(msg.sender.call.value(_am)()) {
            TransferLog.addMessage(msg.sender, _am, "CashOut");
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
    
    function addMessage(address _adr, uint _val, string _data) public {
        Message memory newMsg = Message({
            Sender: _adr,
            Data: _data,
            Val: _val,
            Time: now
        });
        
        History.push(newMsg);
    }
}