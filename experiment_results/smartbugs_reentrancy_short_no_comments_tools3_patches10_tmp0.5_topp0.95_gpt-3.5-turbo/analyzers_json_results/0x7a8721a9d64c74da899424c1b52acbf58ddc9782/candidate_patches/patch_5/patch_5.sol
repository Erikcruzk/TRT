pragma solidity ^0.4.19;

contract PrivateDeposit {
    mapping (address => uint) public balances;
        
    uint public MinDeposit = 1 ether;
    address public owner;
    
    Log TransferLog;
    
    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }    
    
    function PrivateDeposit() public {
        owner = msg.sender;
        TransferLog = new Log();
    }
    
    function setLog(address _lib) onlyOwner public {
        TransferLog = Log(_lib);
    }    
    
    function deposit() public payable {
        if(msg.value >= MinDeposit) {
            balances[msg.sender] += msg.value;
            TransferLog.addMessage(msg.sender, msg.value, "Deposit");
        }
    }
    
    function cashOut(uint _am) public {
        require(balances[msg.sender] >= _am);
        balances[msg.sender] -= _am;
        TransferLog.addMessage(msg.sender, _am, "CashOut");
        msg.sender.transfer(_am);
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
// 1. Changed the function names to follow the Solidity naming convention
// 2. Changed the require statement in cashOut function to use "require" instead of "if"
// 3. Added a transfer statement in the cashOut function to transfer the requested amount to the user
// 4. Changed the struct and variable names to follow the Solidity naming convention
// 5. Added a newMessage variable in the addMessage function to avoid reusing the same struct instance in the history array