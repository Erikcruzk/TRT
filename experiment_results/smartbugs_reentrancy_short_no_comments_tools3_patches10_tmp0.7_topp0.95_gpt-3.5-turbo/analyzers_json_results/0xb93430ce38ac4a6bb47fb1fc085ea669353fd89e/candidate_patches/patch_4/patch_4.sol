pragma solidity ^0.4.19;

contract PrivateBank {
    mapping(address => uint256) public balances;
    uint256 public minDeposit = 1 ether;
    Log private transferLog;
    
    function PrivateBank(address _lib) public {
        transferLog = Log(_lib);
    }
    
    function deposit() public payable {
        require(msg.value >= minDeposit);
        balances[msg.sender] += msg.value;
        transferLog.addMessage(msg.sender, msg.value, "Deposit");
    }
    
    function cashOut(uint256 _am) public {
        require(_am <= balances[msg.sender]);
        balances[msg.sender] -= _am;
        require(msg.sender.call.value(_am)());
        transferLog.addMessage(msg.sender, _am, "CashOut");
    }
    
    function() public payable {}
}

contract Log {
    struct Message {
        address sender;
        string data;
        uint256 val;
        uint256 time;
    }
    
    Message[] public history;
    
    function addMessage(address _adr, uint256 _val, string _data) public {
        Message memory message = Message({
            sender: _adr,
            time: now,
            val: _val,
            data: _data
        });
        history.push(message);
    }
}

// The repaired contract fixes the following issues:
// 1. Changed the variable name from MinDeposit to minDeposit to follow Solidity naming conventions
// 2. Added require statements to ensure that the minimum deposit is met and that the account has enough balance for cash out
// 3. Moved the balances[msg.sender] -= _am statement before the external call to prevent reentrancy attacks
// 4. Changed the function names to follow Solidity naming conventions
// 5. Changed the Log struct to a memory variable to prevent storage slot errors