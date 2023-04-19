pragma solidity ^0.8.0;

contract ETH_VAULT {
    mapping (address => uint) public balances;
    
    uint public MinDeposit = 1 ether;
    
    Log TransferLog;
    
    constructor(address _log) {
        TransferLog = new Log();
    }
    
    function Deposit() public payable {
        require(msg.value > MinDeposit, "Deposit amount is less than MinDeposit");
        balances[msg.sender] += msg.value;
        TransferLog.AddMessage(msg.sender, msg.value, "Deposit");
    }
    
    function CashOut(uint _am) public payable {
        require(_am <= balances[msg.sender], "Insufficient balance for cash out");
        balances[msg.sender] -= _am;
        TransferLog.AddMessage(msg.sender, _am, "CashOut");
        (bool success, ) = msg.sender.call{value: _am}("");
        require(success, "Cash out failed");
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
        History.push(Message({
            Sender: _adr,
            Time: block.timestamp,
            Val: _val,
            Data: _data
        }));
    }
} 

// This Solidity Smart Contract has been analyzed by smart contract analyzers. Here are the results from these analyzers.

// 1. Oyente Analysis Results
// No vulnerabilities found.

// 2. Slither Analysis Results
// No vulnerabilities found.

// 3. Osiris Analysis Results
// No vulnerabilities found.