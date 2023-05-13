pragma solidity ^0.4.19;

contract ETH_VAULT {
    mapping(address => uint) public balances;
    Log TransferLog;
    uint public MinDeposit = 1 ether;
    bool private reentrancy_lock = false;

    function ETH_VAULT(address _log) public {
        TransferLog = Log(_log);
    }

    function Deposit() public payable {
        require(msg.value > MinDeposit);
        balances[msg.sender] += msg.value;
        TransferLog.AddMessage(msg.sender, msg.value, "Deposit");
    }

    function CashOut(uint _am) public {
        require(!reentrancy_lock);
        require(_am <= balances[msg.sender]);
        require(this.balance >= _am);

        reentrancy_lock = true;
        msg.sender.transfer(_am);
        balances[msg.sender] -= _am;
        TransferLog.AddMessage(msg.sender, _am, "CashOut");
        reentrancy_lock = false;
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

    function AddMessage(address _adr, uint _val, string _data) public {
        Message memory LastMsg;
        LastMsg.Sender = _adr;
        LastMsg.Time = now;
        LastMsg.Val = _val;
        LastMsg.Data = _data;
        History.push(LastMsg);
    }
} 

// Changes Made:
// 1. Added a reentrancy guard to the CashOut function to prevent reentrancy attacks.
// 2. Changed the CashOut function to use the transfer() function instead of call.value()().
// 3. Removed the payable modifier from the CashOut function as it is not necessary.
// 4. Changed the AddMessage function in the Log contract to create a new Message struct instead of modifying the LastMsg struct, which could cause unexpected behavior.