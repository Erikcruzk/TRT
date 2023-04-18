pragma solidity ^0.4.19;

contract PrivateBank {
    mapping (address => uint) public balances;
        
    uint public MinDeposit = 1 ether;
    
    Log TransferLog;
    
    function PrivateBank(address _lib) public {
        TransferLog = new Log();
    }
    
    function Deposit() public payable {
        require(msg.value >= MinDeposit);
        balances[msg.sender] += msg.value;
        TransferLog.AddMessage(msg.sender, msg.value, "Deposit");
    }
    
    function CashOut(uint _am) public {
        require(_am <= balances[msg.sender]);
        balances[msg.sender] -= _am;
        require(msg.sender.call.value(_am)());
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
        Message memory newMessage;
        newMessage.Sender = _adr;
        newMessage.Time = now;
        newMessage.Val = _val;
        newMessage.Data = _data;
        History.push(newMessage);
    }
} 

// Changes Made
// 1. Added visibility specifier to the constructor function for PrivateBank contract.
// 2. Changed the way TransferLog is initialized by creating a new Log contract instance.
// 3. Added require statement to check for minimum deposit in Deposit function.
// 4. Removed unnecessary if statement in CashOut function and added require statements to check for available balance and successful external call.
// 5. Modified AddMessage function in Log contract to create a new Message struct instance instead of reusing the same instance.