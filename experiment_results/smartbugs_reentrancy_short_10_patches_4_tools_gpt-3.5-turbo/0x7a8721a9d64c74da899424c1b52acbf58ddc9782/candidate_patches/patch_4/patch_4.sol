/*
 * @source: etherscan.io 
 * @author:
 * @vulnerable_at_lines: 52
 */

pragma solidity ^0.4.19;

contract PrivateDeposit {
    mapping (address => uint) public balances;
    uint public MinDeposit = 1 ether;
    address public owner;
    Log TransferLog;
    bool private locked;

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    modifier noReentrancy() {
        require(!locked);
        locked = true;
        _;
        locked = false;
    }

    function PrivateDeposit() public {
        owner = msg.sender;
        TransferLog = new Log();
    }

    function setLog(address _lib) public onlyOwner {
        TransferLog = Log(_lib);
    }

    function Deposit() public payable {
        if(msg.value >= MinDeposit) {
            balances[msg.sender] += msg.value;
            TransferLog.AddMessage(msg.sender, msg.value, "Deposit");
        }
    }

    function CashOut(uint _am) public noReentrancy {
        if(_am <= balances[msg.sender]) {
            balances[msg.sender] -= _am;
            if(msg.sender.call.value(_am)()) {
                TransferLog.AddMessage(msg.sender, _am, "CashOut");
            }
        }
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
    Message private LastMsg;

    function AddMessage(address _adr, uint _val, string _data) public {
        LastMsg.Sender = _adr;
        LastMsg.Time = now;
        LastMsg.Val = _val;
        LastMsg.Data = _data;
        History.push(LastMsg);
    }
} 

// Changes Made:
// 1. Added a noReentrancy modifier to prevent reentrancy attacks.
// 2. Changed the require statement in the onlyOwner modifier to check msg.sender instead of tx.origin.
// 3. Made the locked variable private to ensure that it cannot be accessed outside of the contract.
// 4. Changed the order of statements in the CashOut function to first update the balance and then transfer the funds to prevent a reentrancy attack.