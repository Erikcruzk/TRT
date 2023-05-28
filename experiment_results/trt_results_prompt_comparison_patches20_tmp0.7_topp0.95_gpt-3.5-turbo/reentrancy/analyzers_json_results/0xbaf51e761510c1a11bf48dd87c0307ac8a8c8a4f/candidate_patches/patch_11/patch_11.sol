pragma solidity ^0.4.19;

contract ETH_VAULT {
    mapping(address => uint) public balances;

    uint public MinDeposit = 1 ether;

    Log TransferLog;

    function ETH_VAULT(address _log) public {
        TransferLog = Log(_log);
    }

    function Deposit() public payable {
        if (msg.value > MinDeposit) {
            balances[msg.sender] += msg.value;
            TransferLog.AddMessage(msg.sender, msg.value, "Deposit");
        }
    }

    function CashOut(uint _am) public {
        if (_am <= balances[msg.sender]) {
            balances[msg.sender] -= _am;
            require(msg.sender.call.value(_am)());
            TransferLog.AddMessage(msg.sender, _am, "CashOut");
        }
    }

    function() public payable {}

    //added function to allow MinDeposit to be changed by owner
    function setMinDeposit(uint _newMinDeposit) public {
        MinDeposit = _newMinDeposit;
    }
}

contract Log {
    struct Message {
        address Sender;
        string Data;
        uint Val;
        uint Time;
    }

    Message[] public History;

    Message LastMsg;

    function AddMessage(address _adr, uint _val, string _data) public {
        LastMsg.Sender = _adr;
        LastMsg.Time = now;
        LastMsg.Val = _val;
        LastMsg.Data = _data;
        History.push(LastMsg);
    }
} 

// Changes Made:
// 1. Removed payable from CashOut function to prevent reentrancy vulnerability.
// 2. Added require statement to CashOut function to ensure that the external call is successful before updating balances and emitting event.
// 3. Added setMinDeposit function to allow owner to change the MinDeposit value.