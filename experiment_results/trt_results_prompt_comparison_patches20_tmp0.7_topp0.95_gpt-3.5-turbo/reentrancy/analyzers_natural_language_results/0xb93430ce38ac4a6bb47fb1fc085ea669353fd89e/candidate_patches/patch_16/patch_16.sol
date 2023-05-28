pragma solidity ^0.4.19;

contract PrivateBank {
    mapping(address => uint) public balances;

    uint public MinDeposit = 1 ether;

    Log TransferLog;

    function PrivateBank(address _lib) {
        TransferLog = Log(_lib);
    }

    function Deposit() public payable {
        if (msg.value >= MinDeposit) {
            balances[msg.sender] += msg.value;
            TransferLog.AddMessage(msg.sender, msg.value, "Deposit");
        }
    }

    function CashOut(uint _am) {
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
        Message memory LastMsg;
        LastMsg.Sender = _adr;
        LastMsg.Time = now;
        LastMsg.Val = _val;
        LastMsg.Data = _data;
        History.push(LastMsg);
    }
} 

// Changes Made:
// 1. Moved the statement TransferLog.AddMessage(msg.sender, _am, "CashOut") after the external call to prevent reentrancy attack.
// 2. Added a check before the external call to ensure that the user has sufficient funds.
// 3. Added a check before the external call to ensure that the call was successful by using the revert() function.
// 4. In the Log contract, declared the struct variable LastMsg inside the function AddMessage to avoid potential storage errors.