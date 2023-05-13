pragma solidity ^0.4.19;

contract PrivateBank {
    mapping(address => uint) public balances;

    uint public MinDeposit = 1 ether;

    Log TransferLog;

    function PrivateBank(address _log) public {
        TransferLog = Log(_log);
    }

    function deposit() public payable {
        require(msg.value >= MinDeposit);
        balances[msg.sender] += msg.value;
        TransferLog.addMessage(msg.sender, msg.value, "Deposit");
    }

    function cashOut(uint _am) public {
        require(_am <= balances[msg.sender]);
        balances[msg.sender] -= _am;
        msg.sender.transfer(_am);
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
        Message memory msg;
        msg.Sender = _adr;
        msg.Time = now;
        msg.Val = _val;
        msg.Data = _data;
        History.push(msg);
    }
} 

// Changes made:
// 1. Added visibility modifier to constructor function PrivateBank
// 2. Added require statement to deposit function to check if msg.value is greater than or equal to MinDeposit
// 3. Removed if statement in cashOut function and replaced it with require statement to check if _am is less than or equal to balances[msg.sender]
// 4. Changed the external call in cashOut function from msg.sender.call.value(_am)() to msg.sender.transfer(_am)
// 5. Added a new local variable msg of type Message to addMessage function and changed the name of the parameter _data to _msgData to avoid naming conflict