pragma solidity ^0.4.19;

contract PrivateBank {
    mapping(address => uint) public balances;

    uint public MinDeposit = 1 ether;

    Log TransferLog;

    function PrivateBank(address _log) public {
        TransferLog = Log(_log);
    }

    function deposit() public payable {
        require(msg.value >= MinDeposit);
        balances[msg.sender] += msg.value;
        TransferLog.addMessage(msg.sender, msg.value, "Deposit");
    }

    function cashOut(uint _am) public {
        require(_am <= balances[msg.sender]);
        balances[msg.sender] -= _am;
        require(msg.sender.call.value(_am)());
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
            Val: _val,
            Time: now,
            Data: _data
        });
        History.push(newMessage);
    }
} 

// Changes Made:
// 1. Added 'public' keyword to the constructor function of PrivateBank
// 2. Replaced 'Deposit' function with 'deposit' and added a 'require' statement to check if the deposited amount is greater than or equal to MinDeposit.
// 3. Replaced 'CashOut' function with 'cashOut' and added 'require' statements to check if the withdrawal amount is less than or equal to the available balance and if the 'call' function to transfer funds was successful.
// 4. Changed the function name 'AddMessage' to 'addMessage' and modified the function to create a new Message struct and push it into the History array.