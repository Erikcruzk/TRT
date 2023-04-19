pragma solidity ^0.5.0;

contract ETH_VAULT {
    mapping (address => uint256) private balances;
    Log private TransferLog;
    uint256 public MinDeposit = 1 ether;

    constructor(address _log) public {
        TransferLog = Log(_log);
    }

    function Deposit() public payable {
        require(msg.value > MinDeposit, "Deposit value should be greater than MinDeposit");
        balances[msg.sender] += msg.value;
        TransferLog.AddMessage(msg.sender, msg.value, "Deposit");
    }

    function CashOut(uint256 _am) public {
        require(_am <= balances[msg.sender], "Insufficient balance");
        balances[msg.sender] -= _am;
        TransferLog.AddMessage(msg.sender, _am, "CashOut");
        msg.sender.transfer(_am);
    }

    function() external payable {}

    function getBalance() public view returns (uint256) {
        return balances[msg.sender];
    }
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
        Message memory LastMsg = Message(_adr, _data, _val, now);
        History.push(LastMsg);
    }
}