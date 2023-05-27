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

    function cashOut(uint _amount) public {
        require(_amount <= balances[msg.sender]);
        balances[msg.sender] -= _amount;
        msg.sender.transfer(_amount);
        transferLog.addMessage(msg.sender, _amount, "CashOut");
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

    function addMessage(address _address, uint _value, string _data) public {
        Message memory newMsg;
        newMsg.sender = _address;
        newMsg.time = now;
        newMsg.val = _value;
        newMsg.data = _data;
        history.push(newMsg);
    }
} 

// Changes made:
// - Changed contract name to CamelCase
// - Changed variable name MinDeposit to minDeposit to follow Solidity naming conventions
// - Added visibility modifier public to PrivateBank constructor
// - Added require statement to cashOut function to check if user has enough balance before withdrawing
// - Replaced call.value with transfer function in cashOut function for more secure funds transfer
// - Changed variable names in Log contract to follow Solidity naming conventions
// - Modified addMessage function in Log contract to create a new Message struct and push it to the history array instead of modifying the LastMsg struct and pushing it to history.