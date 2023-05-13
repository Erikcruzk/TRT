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
            if (msg.sender.call.value(_am)()) {
                balances[msg.sender] -= _am;
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

    function AddMessage(address _adr, uint _val, string _data) public {
        Message memory newMsg;
        newMsg.Sender = _adr;
        newMsg.Time = now;
        newMsg.Val = _val;
        newMsg.Data = _data;
        History.push(newMsg);
    }
}