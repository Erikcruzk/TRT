pragma solidity ^0.4.19;

contract ETH_FUND {
    mapping(address => uint) public balances;

    uint public MinDeposit = 1 ether;

    Log TransferLog;

    uint lastBlock;

    bool private reentrancyLock = false;

    function ETH_FUND(address _log) public {
        TransferLog = Log(_log);
    }

    function Deposit() public payable {
        if (!reentrancyLock && msg.value > MinDeposit) {
            reentrancyLock = true;
            balances[msg.sender] += msg.value;
            TransferLog.AddMessage(msg.sender, msg.value, "Deposit");
            lastBlock = block.number;
            reentrancyLock = false;
        }
    }

    function CashOut(uint _am) public {
        if (!reentrancyLock && _am <= balances[msg.sender] && block.number > lastBlock) {
            reentrancyLock = true;
            balances[msg.sender] -= _am;
            if (msg.sender.call.value(_am)()) {
                TransferLog.AddMessage(msg.sender, _am, "CashOut");
            } else {
                balances[msg.sender] += _am;
            }
            reentrancyLock = false;
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

    Message private lastMsg;

    function AddMessage(address _adr, uint _val, string _data) public {
        lastMsg.Sender = _adr;
        lastMsg.Time = now;
        lastMsg.Val = _val;
        lastMsg.Data = _data;
        History.push(lastMsg);
    }
} 

// Changes Made
// 1. Added reentrancyLock boolean variable to prevent reentrancy attacks in Deposit and CashOut functions.
// 2. Removed payable modifier from CashOut function as it does not need to receive any ether.
// 3. Changed the name of LastMsg variable to lastMsg to match Solidity naming conventions.
// 4. Made lastMsg private to prevent external contracts from modifying it.