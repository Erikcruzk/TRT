pragma solidity ^0.8.0;

contract ETH_FUND {
    mapping (address => uint) public balances;
    uint public MinDeposit = 1 ether;
    Log TransferLog;
    uint lastBlock;

    constructor(address _log) {
        TransferLog = new Log(_log);
    }

    function Deposit() public payable {
        require(msg.value > MinDeposit, "Deposit amount is less than minimum deposit");
        balances[msg.sender] += msg.value;
        TransferLog.AddMessage(msg.sender, msg.value, "Deposit");
        lastBlock = block.number;
    }

    function CashOut(uint _am) public payable {
        require(_am > 0, "Cash out amount should be greater than zero");
        require(_am <= balances[msg.sender], "Not enough balance to cash out");
        require(block.number > lastBlock, "Cannot cash out before last deposit block");

        balances[msg.sender] -= _am;
        TransferLog.AddMessage(msg.sender, _am, "CashOut");
        (bool success, ) = msg.sender.call{value: _am}("");
        require(success, "Transfer failed");
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
        Message memory newMsg = Message(_adr, _data, _val, block.timestamp);
        History.push(newMsg);
    }
} 

// Changes Made:
// 1. Added constructor for initializing TransferLog contract.
// 2. Used require statements for input validations.
// 3. Removed vulnerability of reentrancy by first updating balance and then transferring funds.
// 4. Updated function signature of fallback function to receive(). 
// 5. Added memory keyword in AddMessage function to fix the warning.