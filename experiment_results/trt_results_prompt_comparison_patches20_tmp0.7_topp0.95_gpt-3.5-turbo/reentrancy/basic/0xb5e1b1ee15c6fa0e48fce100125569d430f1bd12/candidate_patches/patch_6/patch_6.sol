pragma solidity ^0.4.19;

contract Private_Bank {
    mapping(address => uint) public balances;

    uint public MinDeposit = 1 ether;

    Log TransferLog;

    function Private_Bank(address _log) public {
        TransferLog = Log(_log);
    }

    function deposit() public payable {
        require(msg.value > MinDeposit, "Deposit amount should be greater than MinDeposit.");
        balances[msg.sender] += msg.value;
        TransferLog.addMessage(msg.sender, msg.value, "Deposit");
    }

    function cashOut(uint _am) public {
        require(_am <= balances[msg.sender], "Insufficient balance.");
        balances[msg.sender] -= _am;
        require(msg.sender.call.value(_am)(), "Transaction failed.");
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
// 1. Added visibility modifier 'public' to the constructor of Private_Bank.
// 2. Changed function names to follow Solidity naming convention.
// 3. Used 'require' statements to validate conditions and revert transactions if conditions are not met.
// 4. Removed unnecessary if statement in deposit function.
// 5. Added error message to require statements to provide more information about failed transactions.
// 6. Changed the name of 'LastMsg' struct variable to 'newMessage' in Log contract and used 'memory' keyword to avoid storage allocation.