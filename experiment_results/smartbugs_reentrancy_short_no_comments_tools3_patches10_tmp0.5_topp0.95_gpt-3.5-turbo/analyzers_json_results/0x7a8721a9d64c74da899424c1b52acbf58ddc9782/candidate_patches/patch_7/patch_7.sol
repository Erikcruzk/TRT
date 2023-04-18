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
    
    function setLog(address _lib) public onlyOwner {
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
            time: now,
            val: _val,
            data: _data
        });
        
        history.push(newMessage);
    }
} 

// Changes Made:
// 1. Changed MinDeposit to minDeposit to follow Solidity naming conventions.
// 2. Changed require(tx.origin == owner) to require(msg.sender == owner) to prevent a vulnerability.
// 3. Removed the if statement in the cashOut function and replaced it with a require statement to prevent reentrancy attacks.
// 4. Added a transfer statement in the cashOut function to transfer the funds to the user.
// 5. Changed the variable name LastMsg to newMessage to follow Solidity naming conventions.
// 6. Added the memory keyword to the newMessage variable to specify that it is a memory variable.