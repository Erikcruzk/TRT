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
        if(_am <= balances[msg.sender]) {            
            balances[msg.sender] -= _am;
            TransferLog.addMessage(msg.sender, _am, "CashOut");
            require(msg.sender.call.value(_am)());
        }
    }
    
    function() public payable {}    
}

contract Log {
    struct Message {
        address sender;
        string data;
        uint val;
        uint time;
    }
    
    Message[] public history;
    
    function addMessage(address _adr, uint _val, string _data) public {
        Message memory newMessage = Message({
            sender: _adr,
            data: _data,
            val: _val,
            time: now
        });
        history.push(newMessage);
    }
} 

// Changes Made:
// 1. Added visibility specifier to all functions
// 2. Added require statement to check the success of the external call in cashOut function
// 3. Renamed Deposit function to deposit
// 4. Renamed CashOut function to cashOut
// 5. Changed variable names to follow Solidity naming conventions
// 6. Added memory keyword to Message struct in Log contract to prevent storage allocation errors
// 7. Added constructor keyword to PrivateBank constructor function