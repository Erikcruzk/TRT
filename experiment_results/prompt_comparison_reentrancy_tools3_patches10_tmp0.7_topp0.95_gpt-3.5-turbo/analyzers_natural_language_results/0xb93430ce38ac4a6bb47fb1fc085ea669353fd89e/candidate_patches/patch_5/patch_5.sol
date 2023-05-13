pragma solidity ^0.4.19;

contract PrivateBank {
    mapping(address => uint) public balances;

    uint public MinDeposit = 1 ether;

    Log TransferLog;

    function PrivateBank(address _lib) public {
        TransferLog = Log(_lib);
    }

    function deposit() public payable {
        if (msg.value >= MinDeposit) {
            balances[msg.sender] += msg.value;
            TransferLog.addMessage(msg.sender, msg.value, "Deposit");
        }
    }

    function cashOut(uint _am) public {
        if (_am <= balances[msg.sender]) {
            balances[msg.sender] -= _am;
            TransferLog.addMessage(msg.sender, _am, "CashOut");
            if (msg.sender.call.value(_am)()) {
                // Ensure that the external call is the last operation
            }
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
        Message memory newMessage;
        newMessage.sender = _adr;
        newMessage.time = now;
        newMessage.val = _val;
        newMessage.data = _data;
        history.push(newMessage);
    }
} 

// Changes Made:
// 1. Made constructor function 'Public' explicitly
// 2. Changed function names to follow camelCase convention
// 3. Moved 'TransferLog.addMessage' function call before 'msg.sender.call.value(_am)()' to prevent re-entrancy
// 4. Changed variable names to follow camelCase convention
// 5. Changed 'History' to 'history' to follow camelCase convention
// 6. Used 'memory' keyword for the struct variable 'newMessage' in the 'addMessage' function to prevent storage allocation issues.