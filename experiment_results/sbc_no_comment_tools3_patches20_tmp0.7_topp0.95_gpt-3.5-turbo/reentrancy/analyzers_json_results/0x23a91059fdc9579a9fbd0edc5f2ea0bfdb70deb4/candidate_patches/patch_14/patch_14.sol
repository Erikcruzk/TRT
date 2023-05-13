pragma solidity ^0.4.19;

contract PrivateBank {
    mapping(address => uint) public balances;

    uint public MinDeposit = 1 ether;

    Log TransferLog;

    function PrivateBank(address _log) public {
        TransferLog = Log(_log);
    }

    function Deposit() public payable {
        require(msg.value >= MinDeposit);
        balances[msg.sender] += msg.value;
        TransferLog.AddMessage(msg.sender, msg.value, "Deposit");
    }

    function CashOut(uint _am) public {
        require(_am <= balances[msg.sender]);
        balances[msg.sender] -= _am;
        msg.sender.transfer(_am);
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

    function AddMessage(address _adr, uint _val, string _data) public {
        Message memory LastMsg;
        LastMsg.Sender = _adr;
        LastMsg.Time = now;
        LastMsg.Val = _val;
        LastMsg.Data = _data;
        History.push(LastMsg);
    }
} 

// The changes made include:
// 1. Adding the visibility keyword 'public' to the constructor function of PrivateBank
// 2. Using the 'require' statement to check that the deposit amount is greater than or equal to the minimum deposit required
// 3. Removing the nested if statement in the CashOut function and replacing it with a 'require' statement to check that the withdrawal amount is less than or equal to the balance of the account
// 4. Changing the call to transfer in the CashOut function to use the transfer function instead, to prevent reentrancy attacks
// 5. Adding a local variable to the AddMessage function in the Log contract to prevent overwriting of previous messages.