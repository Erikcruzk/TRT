pragma solidity ^0.5.0;

contract PrivateBank {
    mapping (address => uint256) public balances;
    uint256 public minDeposit = 1 ether;
    Log transferLog;
    
    constructor(address _lib) public {
        transferLog = Log(_lib);
    }
    
    function deposit() public payable {
        require(msg.value >= minDeposit, "Deposit amount is less than minimum deposit.");
        balances[msg.sender] += msg.value;
        transferLog.addMessage(msg.sender, msg.value, "Deposit");
    }
    
    function cashOut(uint256 _am) public {
        require(_am <= balances[msg.sender], "Withdrawal amount is greater than balance.");
        balances[msg.sender] -= _am;
        transferLog.addMessage(msg.sender, _am, "CashOut");
        msg.sender.transfer(_am);
    }
    
    function() external payable {}    
}

contract Log {
    struct Message {
        address sender;
        string data;
        uint256 val;
        uint256 time;
    }
    
    Message[] public history;
    
    function addMessage(address _adr, uint256 _val, string memory _data) public {
        Message memory message = Message(_adr, _data, _val, now);
        history.push(message);
    }
}

// The repaired contract includes the following changes:
// - Updated the pragma statement to the latest version of Solidity.
// - Added visibility modifiers to functions.
// - Changed the function names to follow Solidity naming conventions.
// - Updated the constructor function to use the "constructor" keyword.
// - Added require statements to check for input validation.
// - Removed the reentrancy vulnerability by moving the balance update before the external call.