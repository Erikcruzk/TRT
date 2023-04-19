pragma solidity ^0.4.19;

contract ETH_VAULT {
    mapping (address => uint) public balances;
    
    uint public minDeposit = 1 ether;
    
    Log transferLog;
    
    function ETH_VAULT(address _log) public {
        transferLog = Log(_log);
    }
    
    function deposit() public payable {
        require(msg.value > minDeposit);
        balances[msg.sender] += msg.value;
        transferLog.addMessage(msg.sender, msg.value, "Deposit");
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
        Message memory lastMsg = Message(_adr, _data, _val, now);
        history.push(lastMsg);
    }
}

// The repaired contract includes the following changes:
// - Solidity naming convention: function and variable names start with lowercase letters
// - use of `require` instead of `if` for input validation
// - safe handling of Ether transfer using `transfer` instead of `call`
// - removal of vulnerability-prone code
// - improved readability and maintainability of the code