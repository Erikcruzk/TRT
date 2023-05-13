pragma solidity ^0.4.19;

contract PrivateBank {
    mapping(address => uint) public balances;

    uint public MinDeposit = 1 ether;

    Log TransferLog;

    function PrivateBank(address _log) public {
        TransferLog = Log(_log);
    }

    function deposit() public payable {
        if (msg.value >= MinDeposit) {
            balances[msg.sender] += msg.value;
            TransferLog.addMessage(msg.sender, msg.value, "Deposit");
        }
    }

    function cashOut(uint _am) public {
        require(_am <= balances[msg.sender]); // requires that the balance of the sender is greater than or equal to the value to be withdrawn
        balances[msg.sender] -= _am;
        msg.sender.transfer(_am); // sends the value to the sender
        TransferLog.addMessage(msg.sender, _am, "CashOut");
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

    function addMessage(address _adr, uint _val, string _data) public {
        Message memory LastMsg; // creates a new instance of the message struct
        LastMsg.Sender = _adr;
        LastMsg.Time = now;
        LastMsg.Val = _val;
        LastMsg.Data = _data;
        History.push(LastMsg);
    }
}

// Changes made:
// 1. Added public visibility to constructor function PrivateBank
// 2. Changed function names to follow Solidity best practices (lowercase for functions)
// 3. Added require statement in cashOut function to prevent underflow
// 4. Changed call.value() to transfer() to prevent reentrancy vulnerability
// 5. Added memory keyword to create a new instance of the message struct in addMessage function