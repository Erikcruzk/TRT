pragma solidity ^0.8.0;

contract ETH_FUND {
    mapping(address => uint) public balances;

    uint public MinDeposit = 1 ether;

    Log TransferLog;

    uint lastBlock;

    constructor(address _log) {
        TransferLog = new Log(_log);
    }

    function Deposit() public payable {
        require(msg.value > MinDeposit, "Deposit amount should be greater than MinDeposit");
        balances[msg.sender] += msg.value;
        TransferLog.AddMessage(msg.sender, msg.value, "Deposit");
        lastBlock = block.number;
    }

    function CashOut(uint _am) public payable {
        require(_am <= balances[msg.sender], "Insufficient balance");
        require(block.number > lastBlock, "Can't cash out yet");
        balances[msg.sender] -= _am;
        TransferLog.AddMessage(msg.sender, _am, "CashOut");
        (bool success, ) = msg.sender.call{value: _am}("");
        require(success, "Transfer failed.");
    }

    receive() external payable {}

    fallback() external payable {}
}

contract Log {
    struct Message {
        address Sender;
        string Data;
        uint Val;
        uint Time;
    }

    Message[] public History;

    Message LastMsg;

    function AddMessage(address _adr, uint _val, string memory _data) public {
        LastMsg.Sender = _adr;
        LastMsg.Time = block.timestamp;
        LastMsg.Val = _val;
        LastMsg.Data = _data;
        History.push(LastMsg);
    }
} 

// The changes made in the contract are:
// 1. Added constructor keyword for constructor function.
// 2. Replaced Log(_log) with new Log(_log) to create a new instance of Log contract.
// 3. Added require statements to check for conditions before executing code.
// 4. Replaced now with block.timestamp as now is deprecated in Solidity 0.8.0.
// 5. Replaced function() with receive() and fallback() functions as function() is deprecated in Solidity 0.8.0.
// 6. Added memory keyword for string parameter in AddMessage() function.