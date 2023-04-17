/*
 * @source: etherscan.io 
 * @author:
 * @vulnerable_at_lines: 40
 */

pragma solidity ^0.4.19;

contract Private_Bank {
    mapping (address => uint) public balances;
    uint public MinDeposit = 1 ether;
    Log TransferLog;
    bool private stopped = false;

    function Private_Bank(address _log) public {
        TransferLog = Log(_log);
    }

    function Deposit() public payable {
        require(!stopped);
        require(msg.value > MinDeposit);
        balances[msg.sender] += msg.value;
        TransferLog.AddMessage(msg.sender, msg.value, "Deposit");
    }

    function CashOut(uint _am) public payable {
        require(!stopped);
        require(_am <= balances[msg.sender]);
        balances[msg.sender] -= _am;
        TransferLog.AddMessage(msg.sender, _am, "CashOut");
        require(msg.sender.call.value(_am)());
    }

    function toggleContractActive() public {
        require(msg.sender == address(0x123)); // Replace with a privileged address
        stopped = !stopped;
    }

    function() public payable {}

}

contract Log {
    struct Message {
        address Sender;
        string  Data;
        uint Val;
        uint  Time;
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

// Changes Made:
// 1. Added a circuit breaker to stop the contract from executing functions.
// 2. Added require statements to check for conditions before execution.
// 3. Changed the order of execution of statements in the CashOut function to prevent reentrancy vulnerability.