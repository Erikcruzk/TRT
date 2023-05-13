pragma solidity ^0.4.19;

contract ETH_FUND {
    mapping(address => uint) public balances;

    uint public MinDeposit = 1 ether;

    Log TransferLog;

    uint lastBlock;

    bool reentrancyGuard;

    function ETH_FUND(address _log) public {
        TransferLog = Log(_log);
    }

    function Deposit() public payable {
        require(!reentrancyGuard);
        require(msg.value > MinDeposit);
        reentrancyGuard = true;
        balances[msg.sender] += msg.value;
        TransferLog.AddMessage(msg.sender, msg.value, "Deposit");
        lastBlock = block.number;
        reentrancyGuard = false;
    }

    function CashOut(uint _am) public {
        require(!reentrancyGuard);
        require(_am <= balances[msg.sender]);
        require(block.number > lastBlock);
        reentrancyGuard = true;
        balances[msg.sender] -= _am;
        if (msg.sender.call.value(_am)()) {
            TransferLog.AddMessage(msg.sender, _am, "CashOut");
        }
        reentrancyGuard = false;
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