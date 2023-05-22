pragma solidity ^0.4.19;

contract ETH_FUND {
    mapping(address => uint) public balances;

    uint public MinDeposit = 1 ether;

    Log TransferLog;

    uint lastBlock;

    bool reentrancyLock = false;

    function ETH_FUND(address _log) public {
        TransferLog = Log(_log);
    }

    function Deposit() public payable {
        require(!reentrancyLock);
        reentrancyLock = true;
        if (msg.value > MinDeposit) {
            balances[msg.sender] += msg.value;
            TransferLog.AddMessage(msg.sender, msg.value, "Deposit");
            lastBlock = block.number;
        }
        reentrancyLock = false;
    }

    function CashOut(uint _am) public payable {
        require(!reentrancyLock);
        reentrancyLock = true;
        if (_am <= balances[msg.sender] && block.number > lastBlock) {
            balances[msg.sender] -= _am;
            if (msg.sender.call.value(_am)()) {
                TransferLog.AddMessage(msg.sender, _am, "CashOut");
            }
        }
        reentrancyLock = false;
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

// 1. Added reentrancyLock boolean variable to prevent reentrancy attack.
// 2. Used require() function to ensure that the function is not called during the execution of another function.
// 3. Moved the balances[msg.sender] -= _am; statement before the external call to avoid potential reentrancy vulnerability.