pragma solidity ^0.8.0;

contract ETH_VAULT {
    mapping(address => uint) public balances;

    uint public MinDeposit = 1 ether;

    Log TransferLog;

    constructor(address _log) {
        TransferLog = new Log();
    }

    function Deposit() public payable {
        require(msg.value > MinDeposit, "Deposit amount should be greater than MinDeposit");
        balances[msg.sender] += msg.value;
        TransferLog.AddMessage(msg.sender, msg.value, "Deposit");
    }

    function CashOut(uint _am) public {
        require(_am <= balances[msg.sender], "Insufficient balance to CashOut");
        (bool sent, ) = msg.sender.call{value: _am}("");
        require(sent, "Failed to send Ether");
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

    function AddMessage(address _adr, uint _val, string memory _data) public {
        Message memory newMsg;
        newMsg.Sender = _adr;
        newMsg.Time = block.timestamp;
        newMsg.Val = _val;
        newMsg.Data = _data;
        History.push(newMsg);
    }
}

// Changes Made
// 1. Updated the pragma version to ^0.8.0
// 2. Updated the constructor function to create a new instance of Log contract
// 3. Replaced if statements with require statements to handle errors efficiently
// 4. Added a receive function to handle incoming Ether transactions
// 5. Updated the AddMessage function to create a new Message struct for each message instead of updating the same LastMsg struct repeatedly.