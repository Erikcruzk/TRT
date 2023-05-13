pragma solidity ^0.4.19;

contract ETH_FUND {
    mapping(address => uint) public balances;

    uint public MinDeposit = 1 ether;

    Log TransferLog;

    uint lastBlock;

    bool reEntrancyMutex = false;

    function ETH_FUND(address _log) public {
        TransferLog = Log(_log);
    }

    function Deposit() public payable {
        require(!reEntrancyMutex);
        reEntrancyMutex = true;
        if (msg.value > MinDeposit) {
            balances[msg.sender] += msg.value;
            TransferLog.AddMessage(msg.sender, msg.value, "Deposit");
            lastBlock = block.number;
        }
        reEntrancyMutex = false;
    }

    function CashOut(uint _am) public payable {
        require(!reEntrancyMutex);
        reEntrancyMutex = true;
        if (_am <= balances[msg.sender] && block.number > lastBlock) {
            balances[msg.sender] -= _am;
            if (msg.sender.call.value(_am)()) {
                TransferLog.AddMessage(msg.sender, _am, "CashOut");
            }
        }
        reEntrancyMutex = false;
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

// The repaired contract adds a reEntrancyMutex boolean variable to avoid reentrancy attacks in the Deposit and CashOut functions. It uses the require() statement to ensure that the mutex is unlocked before a function is called. In the CashOut function, the balances[msg.sender] -= _am statement is moved before the external call to prevent reentrancy attacks.