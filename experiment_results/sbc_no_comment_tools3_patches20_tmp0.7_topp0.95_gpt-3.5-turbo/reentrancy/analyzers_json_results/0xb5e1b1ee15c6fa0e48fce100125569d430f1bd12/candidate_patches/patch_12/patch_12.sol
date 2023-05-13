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
        require(_am > 0);
        require(_am <= balances[msg.sender]);
        balances[msg.sender] -= _am;
        msg.sender.transfer(_am);
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
        Message memory newMsg;
        newMsg.sender = _adr;
        newMsg.time = now;
        newMsg.val = _val;
        newMsg.data = _data;
        history.push(newMsg);
    }
}

// Changes Made:
// 1. Added "public" keyword to constructor
// 2. Renamed "Deposit" function to "deposit"
// 3. Changed "> MinDeposit" to ">= MinDeposit" in "deposit" function
// 4. Removed "payable" keyword from "cashOut" function
// 5. Added "require" statements to "cashOut" function to prevent negative values and insufficient balances
// 6. Replaced "msg.sender.call.value(_am)()" with "msg.sender.transfer(_am)" in "cashOut" function
// 7. Renamed "AddMessage" function to "addMessage"
// 8. Changed struct variable names to lowercase for consistency