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
        require(msg.sender.call.value(_am)());
        balances[msg.sender] -= _am;
        TransferLog.addMessage(msg.sender, _am, "CashOut");
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

// Changes made:
// 1. Added the visibility modifier 'public' to the constructor of Private_Bank
// 2. Changed the function names to follow Solidity naming conventions
// 3. Added 'require' statements to ensure conditions are met before executing code
// 4. Changed the parameter name of the 'cashOut' function to '_am' for consistency
// 5. Removed the unnecessary 'if' statement in the 'deposit' function
// 6. Changed the 'LastMsg' variable in the 'Log' contract to a local variable in the 'addMessage' function
// 7. Changed the 'TransferLog.AddMessage' calls to 'TransferLog.addMessage' to follow Solidity naming conventions