pragma solidity ^0.4.19;

contract Private_Bank {
    mapping(address => uint) public balances;
    uint public MinDeposit = 1 ether;

    Log TransferLog;

    function Private_Bank(address _log) public {
        TransferLog = Log(_log);
    }

    function deposit() public payable {
        require(msg.value > MinDeposit);
        balances[msg.sender] += msg.value;
        TransferLog.addMessage(msg.sender, msg.value, "Deposit");
    }

    function cashOut(uint _am) public {
        require(_am <= balances[msg.sender]);
        balances[msg.sender] -= _am;
        TransferLog.addMessage(msg.sender, _am, "CashOut");
        msg.sender.transfer(_am);
    }

    function() public payable {}

}

contract Log {
    struct Message {
        address Sender;
        string Data;
        uint Val;
        uint Time;
    }

    Message[] public History;

    function addMessage(address _adr, uint _val, string _data) public {
        Message memory newMessage = Message({
            Sender: _adr,
            Time: now,
            Val: _val,
            Data: _data
        });
        History.push(newMessage);
    }
} 

// The repaired smart contract includes the following changes:
// - Added 'public' modifier to the constructor function of Private_Bank
// - Replaced 'CashOut' with 'cashOut' in the function name
// - Used the 'require' statement to check if the condition is met before executing the function
// - Changed the order of the statements in the 'cashOut' function to avoid re-entrancy attacks
// - Removed the unnecessary parentheses from the transfer statement in the 'cashOut' function
// - Added a 'memory' keyword to the newMessage struct in the 'addMessage' function to avoid a potential error.