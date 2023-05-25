pragma solidity ^0.4.19;

contract ETH_FUND {
    mapping(address => uint) public balances;

    uint public MinDeposit = 1 ether;

    Log TransferLog;

    uint lastBlock;

    bool locked;

    function ETH_FUND(address _log) public {
        TransferLog = Log(_log);
        locked = false;
    }

    function Deposit() public payable {
        require(!locked);
        require(msg.value > MinDeposit);
        locked = true;
        balances[msg.sender] += msg.value;
        TransferLog.AddMessage(msg.sender, msg.value, "Deposit");
        lastBlock = block.number;
        locked = false;
    }

    function CashOut(uint _am) public payable {
        require(!locked);
        require(_am <= balances[msg.sender]);
        require(block.number > lastBlock);
        locked = true;
        balances[msg.sender] -= _am;
        TransferLog.AddMessage(msg.sender, _am, "CashOut");
        msg.sender.transfer(_am);
        locked = false;
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
        require(!ETH_FUND(msg.sender).locked);
        LastMsg.Sender = _adr;
        LastMsg.Time = now;
        LastMsg.Val = _val;
        LastMsg.Data = _data;
        History.push(LastMsg);
    }
}