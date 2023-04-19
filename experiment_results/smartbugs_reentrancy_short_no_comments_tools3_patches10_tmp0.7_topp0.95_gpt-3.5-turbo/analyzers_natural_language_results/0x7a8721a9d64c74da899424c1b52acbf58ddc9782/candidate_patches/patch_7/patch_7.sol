pragma solidity ^0.8.0;

contract PrivateDeposit {
    mapping(address => uint256) public balances;

    uint256 public MinDeposit = 1 ether;
    address public owner;

    Log TransferLog;

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can perform this action");
        _;
    }

    constructor() {
        owner = msg.sender;
        TransferLog = new Log();
    }

    function setLog(address _lib) public onlyOwner {
        TransferLog = Log(_lib);
    }

    function Deposit() public payable {
        require(msg.value >= MinDeposit, "Deposit amount must be greater than or equal to MinDeposit");
        balances[msg.sender] += msg.value;
        TransferLog.AddMessage(msg.sender, msg.value, "Deposit");
    }

    function CashOut(uint256 _am) public {
        require(_am <= balances[msg.sender], "Insufficient balance");
        balances[msg.sender] -= _am;
        (bool success, ) = msg.sender.call{value: _am}("");
        require(success, "Transfer failed");
        TransferLog.AddMessage(msg.sender, _am, "CashOut");
    }

    fallback() external payable {}

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

    function AddMessage(address _adr, uint256 _val, string memory _data) public {
        Message memory newMsg = Message(_adr, _data, _val, block.timestamp);
        History.push(newMsg);
    }
}