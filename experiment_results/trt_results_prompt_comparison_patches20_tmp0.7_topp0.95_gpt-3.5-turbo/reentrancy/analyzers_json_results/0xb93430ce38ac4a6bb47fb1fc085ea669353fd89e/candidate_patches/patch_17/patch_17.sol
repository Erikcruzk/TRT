pragma solidity ^0.4.19;

contract PrivateBank {
    mapping(address => uint) public balances;
    uint public MinDeposit = 1 ether;
    Log TransferLog;

    function PrivateBank(address _lib) public {
        TransferLog = Log(_lib);
    }

    function Deposit() public payable {
        require(msg.value >= MinDeposit);
        balances[msg.sender] += msg.value;
        TransferLog.AddMessage(msg.sender, msg.value, "Deposit");
    }

    function CashOut(uint _am) public {
        require(_am <= balances[msg.sender]);
        balances[msg.sender] -= _am;
        TransferLog.AddMessage(msg.sender, _am, "CashOut");
        msg.sender.transfer(_am);
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
// 1. Added visibility modifier to constructor function PrivateBank
// 2. Used require statement instead of if statement in Deposit and CashOut functions
// 3. Moved the statement that records the transaction to before the transfer of funds to prevent reentrancy
// 4. Used transfer() function instead of call.value() in CashOut function
// 5. Added memory keyword to LastMsg in the AddMessage function to prevent data duplication errors.