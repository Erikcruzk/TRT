pragma solidity ^0.4.19;

contract ETH_FUND {
    mapping(address => uint) public balances;
    mapping(address => uint) public lastCashOutBlock;

    uint public MinDeposit = 1 ether;

    Log TransferLog;

    function ETH_FUND(address _log) public {
        TransferLog = Log(_log);
    }

    function Deposit() public payable {
        if (msg.value > MinDeposit) {
            balances[msg.sender] += msg.value;
            TransferLog.AddMessage(msg.sender, msg.value, "Deposit");
            lastCashOutBlock[msg.sender] = block.number;
        }
    }

    function CashOut(uint _am) public {
        require(_am <= balances[msg.sender]);
        require(block.number > lastCashOutBlock[msg.sender]);
        msg.sender.transfer(_am);
        balances[msg.sender] -= _am;
        TransferLog.AddMessage(msg.sender, _am, "CashOut");
        lastCashOutBlock[msg.sender] = block.number;
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