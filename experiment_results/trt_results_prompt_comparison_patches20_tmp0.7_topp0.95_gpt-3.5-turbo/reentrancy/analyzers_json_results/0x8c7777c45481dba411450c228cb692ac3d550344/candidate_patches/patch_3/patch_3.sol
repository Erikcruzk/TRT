pragma solidity ^0.4.19;

contract ETH_VAULT {
    mapping(address => uint) public balances;

    Log TransferLog;

    uint public MinDeposit = 1 ether;

    bool private stopped = false;

    modifier stopInEmergency { require(!stopped); _; }

    function toggleContractStopped() public {
        stopped = !stopped;
    }

    function ETH_VAULT(address _log) public {
        TransferLog = Log(_log);
    }

    function Deposit() public payable stopInEmergency {
        require(msg.value > MinDeposit);
        balances[msg.sender] += msg.value;
        TransferLog.AddMessage(msg.sender, msg.value, "Deposit");
    }

    function CashOut(uint _am) public payable stopInEmergency {
        require(_am <= balances[msg.sender]);
        balances[msg.sender] -= _am;
        require(msg.sender.call.value(_am)());
        TransferLog.AddMessage(msg.sender, _am, "CashOut");
    }

    function() public payable {}

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

    function AddMessage(address _adr, uint _val, string _data) public {
        LastMsg.Sender = _adr;
        LastMsg.Time = now;
        LastMsg.Val = _val;
        LastMsg.Data = _data;
        History.push(LastMsg);
    }
}

// This Solidity Smart Contract has been analyzed by smart contract analyzers. Here are the results from these analyzers.
{
  "securify": {
    "successfull_analysis": true,
    "errors": [],
    "vulnerability_findings": []
  },
  "slither": {
    "successfull_analysis": true,
    "errors": [],
    "vulnerability_findings": []
  },
  "oyente": {
    "successfull_analysis": true,
    "errors": [],
    "vulnerability_findings": []
  }
} 

// The repaired contract includes the following changes:
// 1. Added a circuit breaker to stop contract execution in emergency.
// 2. Reordered the CashOut function to reduce the risk of reentrancy vulnerability.
// 3. Added require statements to check input conditions and prevent invalid operations.
// 4. Removed unnecessary conditional statements.