pragma solidity ^0.8.0;

contract ETH_VAULT {
    mapping(address => uint) public balances;

    Log TransferLog;

    uint public MinDeposit = 1 ether;

    constructor(address _log) {
        TransferLog = new Log();
    }

    function Deposit() public payable {
        require(msg.value >= MinDeposit, "Deposit amount is less than minimum deposit required");
        balances[msg.sender] += msg.value;
        TransferLog.AddMessage(msg.sender, msg.value, "Deposit");
    }

    function CashOut(uint _am) public payable {
        require(_am <= balances[msg.sender], "Insufficient balance");
        balances[msg.sender] -= _am;
        require(payable(msg.sender).send(_am), "Transaction failed");
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

    function AddMessage(address _adr, uint _val, string memory _data) public {
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
// 1. Added constructor instead of a function to initialize TransferLog
// 2. Used require statements instead of if statements for better security
// 3. Changed the CashOut function to first reduce the balance and then transfer the amount to the user
// 4. Added a receive function to receive ether sent to the contract