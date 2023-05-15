pragma solidity ^0.4.19;

contract ETH_FUND {
    mapping(address => uint) public balances;

    uint public MinDeposit = 1 ether;

    Log TransferLog;

    uint lastBlock;

    function ETH_FUND(address _log) public {
        TransferLog = Log(_log);
    }

    function Deposit() public payable {
        if (msg.value >= MinDeposit) { // changed '>' to '>='
            balances[msg.sender] += msg.value;
            TransferLog.AddMessage(msg.sender, msg.value, "Deposit");
            lastBlock = block.number;
        }
    }

    function CashOut(uint _am) public {
        if (_am <= balances[msg.sender] && block.number > lastBlock) {
            if (msg.sender.call.value(_am)()) {
                balances[msg.sender] -= _am;
                TransferLog.AddMessage(msg.sender, _am, "CashOut");
                lastBlock = block.number; // added to prevent double spending
            }
        }
    }

    function() public payable {}

    function setLastBlock(uint _lastBlock) public { // added function to set lastBlock
        lastBlock = _lastBlock;
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

    function AddMessage(address _adr, uint _val, string _data) public {
        Message memory newMessage = Message(_adr, _data, _val, now); // updated to use memory instead of storage
        History.push(newMessage);
    }
}