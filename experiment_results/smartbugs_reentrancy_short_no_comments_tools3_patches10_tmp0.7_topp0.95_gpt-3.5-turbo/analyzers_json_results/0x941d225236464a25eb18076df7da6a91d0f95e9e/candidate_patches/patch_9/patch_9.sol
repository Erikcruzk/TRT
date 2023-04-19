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
        if (msg.value > MinDeposit) {
            balances[msg.sender] += msg.value;
            TransferLog.AddMessage(msg.sender, msg.value, "Deposit");
            lastBlock = block.number;
        }
    }

    function CashOut(uint256 _am) public payable {
        if (_am <= balances[msg.sender] && block.number > lastBlock) {
            balances[msg.sender] -= _am;
            TransferLog.AddMessage(msg.sender, _am, "CashOut");
            (bool success, ) = msg.sender.call{value: _am}("");
            require(success, "Transfer failed.");
        }
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
        Message memory LastMsg;
        LastMsg.Sender = _adr;
        LastMsg.Time = block.timestamp;
        LastMsg.Val = _val;
        LastMsg.Data = _data;
        History.push(LastMsg);
    }
} 

// Changes Made:
// 1. Updated the pragma version to 0.8.0
// 2. Added constructor keyword to the constructor
// 3. Added receive() external payable{} function
// 4. Added memory keyword to the string parameter in AddMessage function of Log contract
// 5. Initialized the LastMsg struct in the AddMessage function of Log contract
// 6. Moved the balances[msg.sender] -= _am; and TransferLog.AddMessage(msg.sender, _am, "CashOut"); statements before the external call to prevent re-entrancy vulnerability
// 7. Added require statement to ensure successful transfer of funds in CashOut function