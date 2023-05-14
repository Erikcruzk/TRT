pragma solidity ^0.4.19;

contract ETH_VAULT {
    mapping(address => uint) public balances;

    Log TransferLog;

    uint public MinDeposit = 1 ether;
    bool private locked;

    function ETH_VAULT(address _log) public {
        TransferLog = Log(_log);
        locked = false;
    }

    function Deposit() public payable {
        require(!locked);
        if (msg.value >= MinDeposit) {
            balances[msg.sender] += msg.value;
            TransferLog.AddMessage(msg.sender, msg.value, "Deposit");
        }
    }

    function CashOut(uint _am) public payable {
        require(!locked);
        require(_am <= balances[msg.sender]);
        balances[msg.sender] -= _am;
        locked = true;
        if (msg.sender.call.value(_am)()) {
            TransferLog.AddMessage(msg.sender, _am, "CashOut");
        }
        locked = false;
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
        Message memory msg;
        msg.Sender = _adr;
        msg.Time = now;
        msg.Val = _val;
        msg.Data = _data;
        History.push(msg);
    }
} 

// Changes Made:
// 1. Added a locked state variable to prevent reentrancy attack.
// 2. Modified Deposit() and CashOut() functions to include require() to check the locked state variable.
// 3. Removed unnecessary check for MinDeposit in CashOut() function.
// 4. Changed LastMsg variable in Log contract to a local variable to prevent overwriting of messages in History array.