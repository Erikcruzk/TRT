pragma solidity ^0.4.19;

contract ETH_VAULT {
    mapping(address => uint) public balances;

    Log TransferLog;

    uint public MinDeposit = 1 ether;
    bool private locked;

    function ETH_VAULT(address _log) public {
        TransferLog = Log(_log);
    }

    function Deposit() public payable {
        require(!locked);
        require(msg.value > MinDeposit);
        locked = true;
        balances[msg.sender] += msg.value;
        TransferLog.AddMessage(msg.sender, msg.value, "Deposit");
        locked = false;
    }

    function CashOut(uint _am) public {
        require(!locked);
        require(_am > 0 && balances[msg.sender] >= _am);
        locked = true;
        balances[msg.sender] -= _am;
        msg.sender.transfer(_am);
        TransferLog.AddMessage(msg.sender, _am, "CashOut");
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
        Message memory LastMsg;
        LastMsg.Sender = _adr;
        LastMsg.Time = now;
        LastMsg.Val = _val;
        LastMsg.Data = _data;
        History.push(LastMsg);
    }
}

// Changes Made:
// 1. Added a bool variable 'locked' to prevent reentrancy attack.
// 2. Used 'require' statements to validate conditions before executing the code.
// 3. Replaced 'call.value' with 'transfer' in the CashOut function to prevent reentrancy attack.
// 4. In the Log contract, created a new struct 'LastMsg' to avoid overwriting previous messages.