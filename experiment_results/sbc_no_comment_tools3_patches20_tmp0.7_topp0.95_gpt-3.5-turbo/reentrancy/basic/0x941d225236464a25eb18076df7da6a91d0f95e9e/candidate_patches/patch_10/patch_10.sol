pragma solidity ^0.8.0;

contract ETH_FUND {
    mapping(address => uint) public balances;

    uint public MinDeposit = 1 ether;

    Log TransferLog;

    uint lastBlock;

    constructor(address _log) {
        TransferLog = new Log();
    }

    function Deposit() public payable {
        require(msg.value >= MinDeposit, "Deposit amount should be greater than minimum deposit amount");
        balances[msg.sender] += msg.value;
        TransferLog.AddMessage(msg.sender, msg.value, "Deposit");
        lastBlock = block.number;
    }

    function CashOut(uint _am) public payable {
        require(_am <= balances[msg.sender], "Insufficient balance");
        require(block.number > lastBlock, "Wait for next block");
        (bool success,) = msg.sender.call{value:_am}("");
        require(success, "Transfer failed");
        balances[msg.sender] -= _am;
        TransferLog.AddMessage(msg.sender, _am, "CashOut");
    }

    receive() external payable {}

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

    function AddMessage(address _adr, uint _val, string memory _data) public {
        LastMsg.Sender = _adr;
        LastMsg.Time = block.timestamp;
        LastMsg.Val = _val;
        LastMsg.Data = _data;
        History.push(LastMsg);
    }
}