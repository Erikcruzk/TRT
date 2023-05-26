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
        if (msg.value > MinDeposit) {
            balances[msg.sender] += msg.value;
            TransferLog.AddMessage(msg.sender, msg.value, "Deposit", block.number);
            lastBlock = block.number;
        }
    }

    function CashOut(uint _am) public payable {
        if (_am <= balances[msg.sender] && block.number > lastBlock) {
            balances[msg.sender] -= _am;
            TransferLog.AddMessage(msg.sender, _am, "CashOut", block.number);
            msg.sender.transfer(_am);
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
        uint BlockNumber;
    }

    Message[] public History;

    function AddMessage(address _adr, uint _val, string _data, uint _blockNumber) public {
        Message memory message = Message(_adr, _data, _val, now, _blockNumber);
        History.push(message);
    }
}