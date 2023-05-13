pragma solidity ^0.4.19;

contract ETH_FUND {
    mapping(address => uint) public balances;

    uint public MinDeposit = 1 ether;

    Log TransferLog;

    uint lastBlock;

    bool private reEntrancyMutex = false;

    function ETH_FUND(address _log) public {
        TransferLog = Log(_log);
    }

    function Deposit() public payable {
        require(!reEntrancyMutex);
        require(msg.value > MinDeposit);
        reEntrancyMutex = true;
        balances[msg.sender] += msg.value;
        TransferLog.AddMessage(msg.sender, msg.value, "Deposit");
        lastBlock = block.number;
        reEntrancyMutex = false;
    }

    function CashOut(uint _am) public {
        require(!reEntrancyMutex);
        require(_am <= balances[msg.sender]);
        require(block.number > lastBlock);
        reEntrancyMutex = true;
        balances[msg.sender] -= _am;
        msg.sender.transfer(_am);
        TransferLog.AddMessage(msg.sender, _am, "CashOut");
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

// The contract has been repaired to prevent reentrancy attacks. The Deposit and CashOut functions now use the reEntrancyMutex to prevent recursive calls. The CashOut function uses transfer() instead of call.value to prevent reentrancy attacks. The require statements have also been used to check for conditions before executing the corresponding functions.