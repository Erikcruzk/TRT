pragma solidity ^0.8.0;

contract ETH_VAULT {
    mapping (address => uint256) public balances;
    
    Log TransferLog;
    
    uint256 public MinDeposit = 1 ether;
    
    constructor(address _log) {
        TransferLog = new Log();
    }
    
    function Deposit() public payable {
        require(msg.value > MinDeposit, "Deposit amount must be greater than minimum deposit");
        balances[msg.sender] += msg.value;
        TransferLog.AddMessage(msg.sender, msg.value, "Deposit");
    }
    
    function CashOut(uint256 _am) public {
        require(_am <= balances[msg.sender], "Insufficient balance to withdraw");
        balances[msg.sender] -= _am;
        TransferLog.AddMessage(msg.sender, _am, "CashOut");
        (bool success, ) = msg.sender.call{value: _am}("");
        require(success, "Transfer failed.");
    }
    
    function getContractBalance() public view returns (uint256) {
        return address(this).balance;
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
        Message memory newMessage = Message({
            Sender: _adr,
            Data: _data,
            Val: _val,
            Time: block.timestamp
        });
        History.push(newMessage);
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