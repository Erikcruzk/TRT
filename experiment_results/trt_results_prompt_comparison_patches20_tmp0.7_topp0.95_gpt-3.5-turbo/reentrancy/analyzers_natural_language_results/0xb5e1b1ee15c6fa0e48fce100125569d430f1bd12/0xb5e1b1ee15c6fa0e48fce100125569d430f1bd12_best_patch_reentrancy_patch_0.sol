pragma solidity ^0.4.19;

contract Private_Bank {
    mapping(address => uint) public balances;

    uint public MinDeposit = 1 ether;

    Log TransferLog;

    function Private_Bank(address _log) public {
        TransferLog = Log(_log);
    }

    function Deposit() public payable {
        if (msg.value >= MinDeposit) {
            balances[msg.sender] += msg.value;
            TransferLog.AddMessage(msg.sender, msg.value, "Deposit");
        }
    }

    function CashOut(uint _am) public {
        if (_am <= balances[msg.sender]) {
            balances[msg.sender] -= _am;
            if (!msg.sender.call.value(_am)()) {
                revert();
            }
            TransferLog.AddMessage(msg.sender, _am, "CashOut");
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
        Message memory lastMsg;
        lastMsg.Sender = _adr;
        lastMsg.Time = now;
        lastMsg.Val = _val;
        lastMsg.Data = _data;
        History.push(lastMsg);
    }
} 

// Changes Made:
// 1. Made constructor public in Private_Bank contract
// 2. Changed "> MinDeposit" to ">= MinDeposit" in Deposit function in Private_Bank contract
// 3. Moved the TransferLog.AddMessage function after balance deduction in CashOut function in Private_Bank contract
// 4. Added a check for successful transfer before adding the message to the log in CashOut function in Private_Bank contract
// 5. Created a new Message struct in the Log contract and used it to create a new struct before adding to the History array in the AddMessage function.