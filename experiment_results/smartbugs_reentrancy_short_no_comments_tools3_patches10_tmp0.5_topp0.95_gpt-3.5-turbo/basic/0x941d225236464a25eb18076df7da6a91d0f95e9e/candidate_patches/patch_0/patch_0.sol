pragma solidity ^0.4.19;

contract ETH_FUND {
    mapping (address => uint) public balances;
    uint public MinDeposit = 1 ether;
    Log TransferLog;
    uint lastBlock;

    function ETH_FUND(address _log) public {
        TransferLog = Log(_log);
    }

    function deposit() public payable {
        require(msg.value > MinDeposit); // use require to validate conditions
        balances[msg.sender] += msg.value;
        TransferLog.AddMessage(msg.sender, msg.value, "Deposit");
        lastBlock = block.number;
    }

    function cashOut(uint _am) public {
        require(_am <= balances[msg.sender]); // use require to validate conditions
        require(block.number > lastBlock); // use require to validate conditions
        balances[msg.sender] -= _am;
        if (msg.sender.call.value(_am)()) {
            TransferLog.AddMessage(msg.sender, _am, "CashOut");
        } else {
            balances[msg.sender] += _am;
        }
    }

    function() public payable {}

}

contract Log {
    struct Message {
        address Sender;
        string  Data;
        uint Val;
        uint  Time;
    }
    Message[] public History;
    Message lastMsg; // change LastMsg to lastMsg

    function AddMessage(address _adr, uint _val, string _data) public {
        lastMsg.Sender = _adr;
        lastMsg.Time = now;
        lastMsg.Val = _val;
        lastMsg.Data = _data;
        History.push(lastMsg);
    }
}