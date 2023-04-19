pragma solidity ^0.8.0;

contract ETH_FUND {
    mapping(address => uint256) public balances;

    uint256 public MinDeposit = 1 ether;

    Log TransferLog;

    uint256 lastBlock;

    constructor(address _log) {
        TransferLog = new Log(_log);
    }

    function Deposit() public payable {
        require(msg.value > MinDeposit, "Deposit amount must be greater than minimum deposit");
        balances[msg.sender] += msg.value;
        TransferLog.AddMessage(msg.sender, msg.value, "Deposit");
        lastBlock = block.number;
    }

    function CashOut(uint256 _am) public {
        require(_am <= balances[msg.sender], "Insufficient balance");
        require(block.number > lastBlock, "Cannot withdraw before the last deposit");
        balances[msg.sender] -= _am;
        TransferLog.AddMessage(msg.sender, _am, "CashOut");
        (bool success, ) = msg.sender.call{value: _am}("");
        require(success, "Transfer failed.");
    }

    receive() external payable {}

}

contract Log {
    struct Message {
        address Sender;
        string Data;
        uint256 Val;
        uint256 Time;
    }

    Message[] public History;

    function AddMessage(
        address _adr,
        uint256 _val,
        string memory _data
    ) public {
        History.push(Message(_adr, _data, _val, block.timestamp));
    }
}