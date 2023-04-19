pragma solidity ^0.8.0;

contract PrivateBank {
    mapping(address => uint256) public balances;

    uint256 public MinDeposit = 1 ether;

    Log TransferLog;

    constructor(address _log) {
        TransferLog = new Log(_log);
    }

    function Deposit() public payable {
        require(msg.value >= MinDeposit, "Minimum deposit amount not met");
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
        Message memory newMessage = Message({
            Sender: _adr,
            Time: block.timestamp,
            Val: _val,
            Data: _data
        });
        History.push(newMessage);
    }
} 

// Changes Made:
// 1. Updated Solidity version to 0.8.0
// 2. Added constructor keyword to the constructor function
// 3. Added require statements to check for minimum deposit and sufficient balance in CashOut function
// 4. Moved balance deduction before the external call in CashOut function to prevent reentrancy vulnerability
// 5. Added a new instance of Log contract using the 'new' keyword in the constructor of PrivateBank contract to fix Log contract deployment issue
// 6. Changed 'string' type to 'string memory' in AddMessage function to fix compilation errors.