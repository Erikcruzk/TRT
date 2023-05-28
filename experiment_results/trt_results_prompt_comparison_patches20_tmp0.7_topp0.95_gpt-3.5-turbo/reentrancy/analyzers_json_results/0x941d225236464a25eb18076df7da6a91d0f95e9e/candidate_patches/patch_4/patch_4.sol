pragma solidity ^0.4.19;

contract ETH_FUND {
    mapping(address => uint) public balances;

    uint public MinDeposit = 1 ether;

    Log TransferLog;

    uint lastBlock;

    bool private reentrancyLock = false;

    modifier reentrancyGuard() {
        require(!reentrancyLock);
        reentrancyLock = true;
        _;
        reentrancyLock = false;
    }

    function ETH_FUND(address _log) public {
        TransferLog = Log(_log);
    }

    function Deposit() public payable reentrancyGuard {
        if (msg.value > MinDeposit) {
            balances[msg.sender] += msg.value;
            TransferLog.AddMessage(msg.sender, msg.value, "Deposit");
            lastBlock = block.number;
        }
    }

    function CashOut(uint _am) public payable reentrancyGuard {
        require(_am <= balances[msg.sender], "Insufficient balance");
        require(block.number > lastBlock, "Must wait for one block after last transaction");
        balances[msg.sender] -= _am;
        msg.sender.transfer(_am);
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

    Message LastMsg;

    function AddMessage(address _adr, uint _val, string _data) public {
        LastMsg.Sender = _adr;
        LastMsg.Time = now;
        LastMsg.Val = _val;
        LastMsg.Data = _data;
        History.push(LastMsg);
    }
} 

// Changes Made
// 1. Added reentrancy guard modifier to the Deposit() and CashOut() functions to prevent reentrancy attacks.
// 2. Replaced the call() function with transfer() function in the CashOut() function to prevent reentrancy attacks.
// 3. Added error messages to the require statements in the CashOut() function for better user feedback.