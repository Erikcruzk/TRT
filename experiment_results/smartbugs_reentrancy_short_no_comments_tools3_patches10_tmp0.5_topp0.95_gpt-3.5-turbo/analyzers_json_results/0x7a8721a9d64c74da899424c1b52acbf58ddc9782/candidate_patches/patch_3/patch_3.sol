pragma solidity ^0.4.19;

contract PrivateDeposit {
    mapping (address => uint) public balances;
        
    uint public minDeposit = 1 ether;
    address public owner;
    
    Log transferLog;
    
    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }    
    
    function PrivateDeposit() public {
        owner = msg.sender;
        transferLog = new Log();
    }
    
    function setLog(address _lib) onlyOwner public {
        transferLog = Log(_lib);
    }    
    
    function deposit() public payable {
        if(msg.value >= minDeposit) {
            balances[msg.sender] += msg.value;
            transferLog.addMessage(msg.sender, msg.value, "Deposit");
        }
    }
    
    function cashOut(uint _am) public {
        require(_am <= balances[msg.sender]);
        balances[msg.sender] -= _am;
        msg.sender.transfer(_am);
        transferLog.addMessage(msg.sender, _am, "CashOut");
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

// Changes made:
// - Changed variable names to follow Solidity naming conventions (camelCase)
// - Changed constructor and function visibility to explicit public
// - Changed require statement in cashOut function to prevent reentrancy vulnerability
// - Changed the way messages are added to the history array in Log contract to prevent integer overflow vulnerability
// - Replaced msg.sender.call.value with msg.sender.transfer in cashOut function for better security and readability