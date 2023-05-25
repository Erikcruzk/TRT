pragma solidity ^0.8.0;

contract ETH_FUND {
    mapping(address => uint) public balances;

    uint public MinDeposit = 1 ether;

    Log TransferLog;

    uint lastBlock;

    constructor(address _log) {
        TransferLog = new Log();
    }

    function Deposit() public payable {
        require(msg.value >= MinDeposit, "Amount is less than minimum deposit");
        balances[msg.sender] += msg.value;
        TransferLog.AddMessage(msg.sender, msg.value, "Deposit");
        lastBlock = block.number;
    }

    function CashOut(uint _am) public payable {
        require(_am <= balances[msg.sender], "Not enough balance to withdraw");
        require(block.number > lastBlock, "Wait for the next block to withdraw");
        balances[msg.sender] -= _am;
        TransferLog.AddMessage(msg.sender, _am, "CashOut");
        payable(msg.sender).transfer(_am);
    }

    function() external payable {}
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
        Message memory lastMsg;
        lastMsg.Sender = _adr;
        lastMsg.Time = block.timestamp;
        lastMsg.Val = _val;
        lastMsg.Data = _data;
        History.push(lastMsg);
    }
} 

// Changes Made:
// 1. Added constructor to initialize the TransferLog
// 2. Replaced if statement with require statement in Deposit function
// 3. Replaced if statement with require statements in CashOut function
// 4. Replaced call.value with transfer in CashOut function
// 5. Changed fallback function from public to external
// 6. Added memory keyword in AddMessage function in Log contract.