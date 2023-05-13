pragma solidity ^0.4.19;

contract PrivateBank {
    mapping(address => uint) public balances;

    uint public minDeposit = 1 ether;

    Log transferLog;

    function PrivateBank(address _log) public {
        transferLog = Log(_log);
    }

    function deposit() public payable {
        if (msg.value >= minDeposit) {
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
        Message memory lastMsg = Message(_adr, _data, _val, now);
        history.push(lastMsg);
    }
} 

// Changes Made:
// 1. Changed MinDeposit to minDeposit (lowercase first letter) to follow naming convention
// 2. Added 'public' modifier to all functions
// 3. Replaced if statement in cashOut function with require statement to ensure that it fails if the condition is not met
// 4. Replaced msg.sender.call.value() with msg.sender.transfer() to prevent reentrancy vulnerability
// 5. Changed Log's addMessage function to create a new Message struct instead of modifying the lastMsg variable to prevent overwriting previous messages in the history array.