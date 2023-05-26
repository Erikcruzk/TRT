pragma solidity ^0.4.19;

contract ETH_FUND {
    mapping(address => uint) public balances;

    uint public MinDeposit = 1 ether;

    Log TransferLog;

    uint lastBlock;

    bool private reEntrancyMutex = false;

    modifier preventReEntrancy() {
        require(!reEntrancyMutex);
        reEntrancyMutex = true;
        _;
        reEntrancyMutex = false;
    }

    function ETH_FUND(address _log) public {
        TransferLog = Log(_log);
    }

    function Deposit() public payable preventReEntrancy {
        require(msg.value > MinDeposit);
        balances[msg.sender] += msg.value;
        TransferLog.AddMessage(msg.sender, msg.value, "Deposit");
        lastBlock = block.number;
    }

    function CashOut(uint _am) public preventReEntrancy {
        require(_am <= balances[msg.sender] && block.number > lastBlock);
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

    Message LastMsg;

    function AddMessage(address _adr, uint _val, string _data) public preventReEntrancy {
        LastMsg.Sender = _adr;
        LastMsg.Time = now;
        LastMsg.Val = _val;
        LastMsg.Data = _data;
        History.push(LastMsg);
    }
} 

// The repaired contract adds a mutex to prevent reentrancy attacks in the Deposit and CashOut functions. 
// It also adds require statements to check the validity of inputs before executing transactions.