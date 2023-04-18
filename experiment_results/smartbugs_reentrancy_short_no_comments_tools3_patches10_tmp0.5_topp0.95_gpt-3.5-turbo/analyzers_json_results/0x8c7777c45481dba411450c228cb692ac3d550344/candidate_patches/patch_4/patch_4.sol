pragma solidity ^0.8.0;

contract ETH_VAULT {
    mapping(address => uint256) public balances;

    Log TransferLog;

    uint256 public MinDeposit = 1 ether;

    constructor(address _log) {
        TransferLog = new Log();
    }

    function Deposit() public payable {
        require(msg.value > MinDeposit, "Deposit amount should be greater than MinDeposit");
        balances[msg.sender] += msg.value;
        TransferLog.AddMessage(msg.sender, msg.value, "Deposit");
    }

    function CashOut(uint256 _am) public payable {
        require(_am > 0, "Withdraw amount should be greater than zero");
        require(_am <= balances[msg.sender], "Insufficient balance");
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

    function AddMessage(address _adr, uint256 _val, string memory _data) public {
        Message memory LastMsg;
        LastMsg.Sender = _adr;
        LastMsg.Time = block.timestamp;
        LastMsg.Val = _val;
        LastMsg.Data = _data;
        History.push(LastMsg);
    }
} 

// Changes Made
// 1. Added constructor to initialize TransferLog contract
// 2. Added require statements to check for conditions
// 3. Changed the way of calling TransferLog contract to new contract instance
// 4. Moved the declaration of LastMsg inside AddMessage function and initialized it before use
// 5. Changed the fallback function to receive() external payable {} as fallback function is deprecated in latest Solidity version.