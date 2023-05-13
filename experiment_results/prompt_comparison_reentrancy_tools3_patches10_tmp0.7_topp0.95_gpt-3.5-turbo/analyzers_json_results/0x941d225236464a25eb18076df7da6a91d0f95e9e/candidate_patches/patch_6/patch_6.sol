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
        if (msg.value > MinDeposit) {
            balances[msg.sender] += msg.value;
            lastBlock = block.number;
            TransferLog.AddMessage(msg.sender, msg.value, "Deposit");
        }
    }

    function CashOut(uint _am) public payable {
        if (!_isReEntrancy() && _am <= balances[msg.sender] && block.number > lastBlock) {
            reEntrancyMutex = true;
            balances[msg.sender] -= _am;
            TransferLog.AddMessage(msg.sender, _am, "CashOut");
            reEntrancyMutex = false;
            if (msg.sender.call.value(_am)()) {
                
            }
        }
    }

    function _isReEntrancy() internal view returns (bool) {
        return reEntrancyMutex;
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