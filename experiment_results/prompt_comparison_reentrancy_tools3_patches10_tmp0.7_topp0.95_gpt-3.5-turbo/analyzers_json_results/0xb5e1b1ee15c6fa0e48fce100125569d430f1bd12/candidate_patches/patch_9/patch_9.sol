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
            val: _val,
            data: _data,
            time: now
        });
        history.push(newMessage);
    }
}

// Changes Made:
// 1. Changed the function names to follow the Solidity naming conventions.
// 2. Added "public" access modifier to the constructor.
// 3. Changed the "MinDeposit" variable to "minDeposit" to follow the Solidity naming conventions.
// 4. Added a "require" statement in the "cashOut" function to check if the user has enough balance before withdrawing.
// 5. Changed the "call.value" method to "transfer" method in the "cashOut" function to prevent reentrancy vulnerability.
// 6. Changed the "TransferLog" variable to "transferLog" to follow the Solidity naming conventions.
// 7. Changed the "Message" struct variable names to follow the Solidity naming conventions.
// 8. Changed the "AddMessage" function to "addMessage" to follow the Solidity naming conventions.
// 9. Changed the "LastMsg" variable to a local variable "newMessage" in the "addMessage" function.