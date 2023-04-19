pragma solidity ^0.8.0;

contract ETH_VAULT {
    mapping (address => uint256) public balances;
    
    Log TransferLog;
    
    uint256 public MinDeposit = 1 ether;
    
    constructor(address _log) {
        TransferLog = new Log(_log);
    }
    
    function Deposit() public payable {
        require(msg.value > MinDeposit, "Deposit amount should be greater than MinDeposit");
        balances[msg.sender] += msg.value;
        TransferLog.AddMessage(msg.sender, msg.value, "Deposit");
    }
    
    function CashOut(uint256 _am) public {
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
        uint256 Val;
        uint256 Time;
    }
    
    Message[] public History;
    
    function AddMessage(address _adr, uint256 _val, string memory _data) public {
        Message memory newMsg = Message(_adr, _data, _val, block.timestamp);
        History.push(newMsg);
    }
}

// This Solidity Smart Contract has been analyzed by smart contract analyzers. Here are the results from these analyzers.
{
  "osiris": {
    "successfull_analysis": true,
    "errors": [],
    "vulnerability_findings": []
  },
  "slither": {
    "successfull_analysis": true,
    "errors": [],
    "vulnerability_findings": []
  }
}

// Repaired Solidity Smart Contract with the following changes:
// 1. Added constructor function to initialize TransferLog contract
// 2. Replaced if statement with require statement in Deposit function
// 3. Removed payable modifier from CashOut function
// 4. Reordered statements in CashOut function to prevent reentrancy vulnerability
// 5. Changed fallback function to receive function
// 6. Removed unused variables and fixed formatting