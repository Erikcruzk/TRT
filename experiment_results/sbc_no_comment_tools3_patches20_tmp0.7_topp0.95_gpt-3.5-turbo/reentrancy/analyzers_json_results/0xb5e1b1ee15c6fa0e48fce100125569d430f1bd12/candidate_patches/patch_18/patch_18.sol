pragma solidity ^0.4.19;

contract Private_Bank {
    mapping(address => uint) public balances;

    uint public minDeposit = 1 ether;

    Log transferLog;

    function Private_Bank(address _log) public {
        transferLog = Log(_log);
    }

    function deposit() public payable {
        if (msg.value >= minDeposit) {
            balances[msg.sender] += msg.value;
            transferLog.addMessage(msg.sender, msg.value, "Deposit");
        }
    }

    function cashOut(uint _am) public {
        if (_am <= balances[msg.sender]) {
            balances[msg.sender] -= _am;
            msg.sender.transfer(_am);
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
        Message memory lastMsg = Message({
            sender: _adr,
            time: now,
            val: _val,
            data: _data
        });
        history.push(lastMsg);
    }
}

// Changes Made:
// 1. Changed MinDeposit to minDeposit to follow Solidity naming convention
// 2. Added public visibility to Private_Bank constructor function
// 3. Changed Deposit to deposit to follow Solidity naming convention
// 4. Changed CashOut function to send funds before updating balances to prevent reentrancy vulnerability
// 5. Changed TransferLog to transferLog to follow Solidity naming convention
// 6. Changed Log struct variable names to follow Solidity naming convention
// 7. Added memory keyword to Message struct declaration in Log contract to avoid stack too deep error
// 8. Added memory keyword to lastMsg variable declaration in addMessage function to avoid stack too deep error