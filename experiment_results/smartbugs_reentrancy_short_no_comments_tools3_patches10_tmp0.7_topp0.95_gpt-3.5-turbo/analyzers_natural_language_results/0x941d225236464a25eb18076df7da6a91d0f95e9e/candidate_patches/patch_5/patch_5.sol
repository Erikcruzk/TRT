pragma solidity ^0.8.0;

contract ETH_FUND {
    mapping (address => uint) public balances;
    
    uint public MinDeposit = 1 ether;
    
    Log TransferLog;
    
    uint lastBlock;
    
    constructor(address _log) {
        TransferLog = new Log(_log);
    }
    
    function Deposit() public payable {
        require(msg.value >= MinDeposit, "Deposit amount is less than minimum deposit");
        balances[msg.sender] += msg.value;
        TransferLog.AddMessage(msg.sender, msg.value, "Deposit");
        lastBlock = block.number;
    }
    
    function CashOut(uint _am) public {
        require(_am <= balances[msg.sender], "Insufficient balance to withdraw");
        require(block.number > lastBlock, "Withdrawal not possible at this time");
        balances[msg.sender] -= _am;
        TransferLog.AddMessage(msg.sender, _am, "CashOut");
        (bool success, ) = msg.sender.call{value: _am}("");
        require(success, "Withdrawal failed");
    }
    
    receive() external payable {}
}

contract Log {
    struct Message {
        address Sender;
        string  Data;
        uint Val;
        uint  Time;
    }
    
    Message[] public History;
    
    function AddMessage(address _adr, uint _val, string memory _data) public {
        History.push(Message(_adr, _data, _val, block.timestamp));
    }
}