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
        require(_am <= balances[msg.sender]);
        balances[msg.sender] -= _am;
        msg.sender.transfer(_am);
        TransferLog.AddMessage(msg.sender, _am, "CashOut");
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

// Changes Made:
// 1. Added a constructor to initialize TransferLog as a new instance of Log.
// 2. Added a require statement in CashOut function to prevent underflow.
// 3. Replaced call.value with transfer in CashOut function to prevent reentrancy.
// 4. Changed LastMsg to a local variable in AddMessage function to prevent overwrite of previous messages.