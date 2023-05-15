pragma solidity ^0.4.19;

contract Private_Bank {
    mapping(address => uint) public balances;

    uint public MinDeposit = 1 ether;

    Log public TransferLog;

    function Private_Bank(address _log) public {
        TransferLog = new Log();
    }

    function Deposit() public payable {
        if (msg.value >= MinDeposit) {
            balances[msg.sender] += msg.value;
            TransferLog.AddMessage(msg.sender, msg.value, "Deposit");
        }
    }

    function CashOut(uint _am) public {
        if (_am <= balances[msg.sender]) {
            if (msg.sender.call.value(_am)()) {
                balances[msg.sender] -= _am;
                TransferLog.AddMessage(msg.sender, _am, "CashOut");
            }
        }
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

    function AddMessage(address _adr, uint _val, string _data) public {
        Message memory newMessage;
        newMessage.Sender = _adr;
        newMessage.Time = now;
        newMessage.Val = _val;
        newMessage.Data = _data;
        History.push(newMessage);
    }
} 

// Changes Made:
// 1. Added "public" keyword to the constructor function of Private_Bank contract.
// 2. Initialized the TransferLog variable with a new instance of the Log contract.
// 3. Changed the condition in Deposit function to ">=" instead of ">" to allow deposits of exactly 1 ether.
// 4. Removed "payable" keyword from CashOut function as it does not need to receive any value.
// 5. Created a new Message struct in AddMessage function to avoid updating the values of the LastMsg struct and pushing the same reference multiple times to the History array.