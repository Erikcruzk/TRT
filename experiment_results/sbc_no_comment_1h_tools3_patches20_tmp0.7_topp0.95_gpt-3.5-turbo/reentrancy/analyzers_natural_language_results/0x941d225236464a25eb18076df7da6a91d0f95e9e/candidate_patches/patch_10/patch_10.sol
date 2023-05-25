pragma solidity ^0.8.0;

contract ETH_FUND {
    mapping(address => uint256) public balances;

    uint256 public MinDeposit = 1 ether;

    Log TransferLog;

    uint256 lastBlock;

    constructor(address _log) {
        TransferLog = new Log();
    }

    function Deposit() public payable {
        require(msg.value > MinDeposit, "Deposit amount should be greater than minimum deposit");
        balances[msg.sender] += msg.value;
        TransferLog.AddMessage(msg.sender, msg.value, "Deposit");
        lastBlock = block.number;
    }

    function CashOut(uint256 _am) public payable {
        require(_am <= balances[msg.sender], "Insufficient balance");
        require(block.number > lastBlock, "Can't cash out before last deposit");
        balances[msg.sender] -= _am;
        TransferLog.AddMessage(msg.sender, _am, "CashOut");
        (bool success, ) = msg.sender.call{value: _am}("");
        require(success, "Transfer failed.");
    }

    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }

    function() external payable {}
}

contract Log {
    struct Message {
        address Sender;
        string Data;
        uint256 Val;
        uint256 Time;
    }

    Message[] public History;

    function AddMessage(address _adr, uint256 _val, string memory _data) public {
        Message memory newMessage = Message({
            Sender: _adr,
            Time: block.timestamp,
            Val: _val,
            Data: _data
        });
        History.push(newMessage);
    }
}