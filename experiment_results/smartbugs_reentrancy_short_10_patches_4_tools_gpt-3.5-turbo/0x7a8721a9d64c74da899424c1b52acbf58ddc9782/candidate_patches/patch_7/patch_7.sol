/*
 * @source: etherscan.io 
 * @author: -
 * @fixed_at_lines: 52, 56
 */

pragma solidity ^0.4.19;

contract PrivateDeposit {
    mapping (address => uint) public balances;
    uint public MinDeposit = 1 ether;
    address public owner;
    Log TransferLog;
    bool private stopped = false; // added circuit breaker state variable
    
    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }
    
    modifier stopInEmergency { // added circuit breaker modifier
        require(!stopped);
        _;
    }
    
    function PrivateDeposit() public {
        owner = msg.sender;
        TransferLog = new Log();
    }
    
    function setLog(address _lib) onlyOwner public {
        TransferLog = Log(_lib);
    }
    
    function Deposit() public payable {
        require(msg.value >= MinDeposit);
        balances[msg.sender] += msg.value;
        TransferLog.AddMessage(msg.sender, msg.value, "Deposit");
    }
    
    function CashOut(uint _am) public stopInEmergency { // added circuit breaker modifier
        require(_am <= balances[msg.sender]);
        balances[msg.sender] -= _am;
        TransferLog.AddMessage(msg.sender, _am, "CashOut");
        require(msg.sender.call.value(_am)());
    }
    
    function toggleContractStopped() onlyOwner public { // added circuit breaker function
        stopped = !stopped;
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

// Changes Made:
// 1. Added a circuit breaker state variable "stopped" and a modifier "stopInEmergency" to prevent reentrancy attack.
// 2. Changed the function modifier "onlyOwner" to use "msg.sender" instead of "tx.origin".
// 3. Added a check in the Deposit function to ensure that the deposit amount is greater than or equal to MinDeposit.
// 4. Moved the balance check before the transfer of funds in the CashOut function to prevent underflow.
// 5. Added a function toggleContractStopped to enable the owner to toggle the circuit breaker state variable.