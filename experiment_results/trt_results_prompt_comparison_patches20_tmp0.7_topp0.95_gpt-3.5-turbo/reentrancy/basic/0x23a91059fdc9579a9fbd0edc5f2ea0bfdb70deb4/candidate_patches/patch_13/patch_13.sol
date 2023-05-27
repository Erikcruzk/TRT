pragma solidity ^0.4.19;

contract PrivateBank {
    mapping(address => uint) public balances;

    uint public minDeposit = 1 ether;

    Log public transferLog;

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
        if (msg.sender.call.value(_am)()) {
            transferLog.addMessage(msg.sender, _am, "CashOut");
        } else {
            balances[msg.sender] += _am;
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
        history.push(Message({
            sender: _adr,
            time: now,
            val: _val,
            data: _data
        }));
    }
} 

// Changes made:
// 1. Changed MinDeposit to minDeposit
// 2. Added public access specifier to constructor function
// 3. Changed TransferLog to transferLog
// 4. Added require statement in cashOut function to check if user has sufficient balance
// 5. Reordered the statements in cashOut function to transfer the funds first and then log the message
// 6. Added an else statement in cashOut function to revert the transfer if the call to msg.sender fails
// 7. Changed variable names in Log contract to follow Solidity naming conventions
// 8. Modified addMessage function in Log contract to push a new Message struct directly into the history array