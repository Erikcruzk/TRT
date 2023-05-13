pragma solidity ^0.4.19;

contract PrivateBank {
    mapping(address => uint) public balances;

    uint public MinDeposit = 1 ether;

    Log TransferLog;

    constructor(address _log) public {
        TransferLog = Log(_log);
    }

    function Deposit() public payable {
        if (msg.value >= MinDeposit) {
            balances[msg.sender] += msg.value;
            TransferLog.AddMessage(msg.sender, msg.value, "Deposit");
        }
    }

    function CashOut(uint _am) public {
        require(_am <= balances[msg.sender]);
        require(msg.sender.call.value(_am)());
        balances[msg.sender] -= _am;
        TransferLog.AddMessage(msg.sender, _am, "CashOut");
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
        Message memory LastMsg;
        LastMsg.Sender = _adr;
        LastMsg.Time = now;
        LastMsg.Val = _val;
        LastMsg.Data = _data;
        History.push(LastMsg);
    }
} 

// Changes Made
// 1. Added constructor keyword before the constructor function name.
// 2. Added public keyword before function declarations.
// 3. Added require statements to check for conditions before executing the function.
// 4. Added memory keyword before struct variable declaration.
// 5. Moved the struct variable declaration inside the function to avoid storage allocation.