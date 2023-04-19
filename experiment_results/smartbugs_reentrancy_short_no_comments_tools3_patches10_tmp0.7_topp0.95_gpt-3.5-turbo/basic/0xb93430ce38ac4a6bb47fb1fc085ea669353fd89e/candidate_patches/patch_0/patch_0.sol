pragma solidity ^0.4.19;

contract PrivateBank {
    mapping (address => uint) public balances;
        
    uint public minDeposit = 1 ether;
    
    Log transferLog;
    
    function PrivateBank(address _lib) public {
        transferLog = Log(_lib);
    }
    
    function deposit() public payable {
        if(msg.value >= minDeposit) {
            balances[msg.sender] += msg.value;
            transferLog.addMessage(msg.sender, msg.value, "Deposit");
        }
    }
    
    function cashOut(uint _am) public {
        require(_am <= balances[msg.sender]); // added require statement
        if(msg.sender.call.value(_am)()) {
            balances[msg.sender] -= _am;
            transferLog.addMessage(msg.sender, _am, "CashOut");
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
        Message memory newMessage = Message(_adr, _data, _val, now); // modified to use memory
        history.push(newMessage);
    }
}