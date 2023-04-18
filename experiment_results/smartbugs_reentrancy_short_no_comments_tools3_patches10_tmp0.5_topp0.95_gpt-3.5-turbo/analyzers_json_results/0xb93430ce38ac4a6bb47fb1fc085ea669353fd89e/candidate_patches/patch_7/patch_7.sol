pragma solidity ^0.4.19;

contract PrivateBank {
    mapping (address => uint) public balances;
    uint public MinDeposit = 1 ether;
    Log TransferLog;
    bool private locked;

    modifier noReentrancy() {
        require(!locked);
        locked = true;
        _;
        locked = false;
    }

    function PrivateBank(address _lib) public {
        TransferLog = Log(_lib);
    }
    
    function Deposit() public payable {
        require(msg.value >= MinDeposit);
        balances[msg.sender] += msg.value;
        TransferLog.AddMessage(msg.sender, msg.value, "Deposit");
    }

    function CashOut(uint _am) public noReentrancy {
        require(_am <= balances[msg.sender]);
        balances[msg.sender] -= _am;
        if (msg.sender.call.value(_am)()) {
            TransferLog.AddMessage(msg.sender, _am, "CashOut");
        } else {
            balances[msg.sender] += _am;
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
// 1. Added a noReentrancy modifier to prevent reentrancy attack.
// 2. Replaced if statements with require statements for better security.
// 3. Added a check to ensure that the transfer of funds is successful before updating the balance.