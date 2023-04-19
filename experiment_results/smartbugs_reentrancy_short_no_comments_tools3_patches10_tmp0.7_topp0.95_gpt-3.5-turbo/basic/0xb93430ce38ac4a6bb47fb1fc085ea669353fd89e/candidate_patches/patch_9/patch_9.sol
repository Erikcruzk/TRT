pragma solidity ^0.4.19;

contract PrivateBank {
    mapping (address => uint) public balances;
        
    uint public MinDeposit = 1 ether;
    
    Log TransferLog;
    
    function PrivateBank(address _lib) public {
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
        string Data;
        uint Val;
        uint Time;
    }
    
    Message[] public History;
    
    function AddMessage(address _adr, uint _val, string _data) public {
        Message memory newMsg = Message({
            Sender: _adr,
            Time: now,
            Val: _val,
            Data: _data
        });
        History.push(newMsg);
    }
}