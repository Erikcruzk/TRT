pragma solidity ^0.4.19;

contract Private_Bank {
    mapping(address => uint) public balances;

    uint public MinDeposit = 1 ether;

    Log TransferLog;

    function Private_Bank(address _log) public {
        TransferLog = Log(_log);
    }

    function deposit() public payable {
        if (msg.value >= MinDeposit) {
            balances[msg.sender] += msg.value;
            TransferLog.addMessage(msg.sender, msg.value, "Deposit");
        }
    }

    function cashOut(uint _am) public {
        require(_am <= balances[msg.sender], "Insufficient balance");
        balances[msg.sender] -= _am;
        require(msg.sender.call.value(_am)(), "Transfer failed");
        TransferLog.addMessage(msg.sender, _am, "CashOut");
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
        Message memory newMessage = Message(_adr, _data, _val, now);
        history.push(newMessage);
    }
}

// Changes made:
// 1. Added "public" to constructor function
// 2. Changed function names to follow Solidity naming conventions
// 3. Added require statement in cashOut function to check if the user has sufficient balance
// 4. Moved the call to the external contract to the end of the function to avoid reentrancy vulnerability
// 5. Changed the name of the variables and functions to follow Solidity naming conventions
// 6. Changed the struct variable "LastMsg" to a local variable "newMessage" in Log contract