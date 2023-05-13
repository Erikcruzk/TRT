pragma solidity ^0.4.19;

contract Private_Bank {
    mapping(address => uint) public balances;

    uint public MinDeposit = 1 ether;

    Log TransferLog;

    function Private_Bank(address _log) public {
        TransferLog = Log(_log);
    }

    function deposit() public payable {
        if (msg.value >= MinDeposit) {
            balances[msg.sender] += msg.value;
            TransferLog.addMessage(msg.sender, msg.value, "Deposit");
        }
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
        Message memory newMessage = Message({
            Sender: _adr,
            Data: _data,
            Val: _val,
            Time: now
        });
        History.push(newMessage);
    }
} 

// Changes Made:
// 1. Added 'public' access modifier to the constructor function.
// 2. Renamed 'Deposit' function to 'deposit' and changed the 'if' statement to check if the deposited value is greater than or equal to MinDeposit.
// 3. Renamed 'CashOut' function to 'cashOut' and used the 'require' statement to check if the requested amount is less than or equal to the balance of the requester. Also, used 'transfer' function instead of 'call.value' to send the requested amount to the requester. 
// 4. Added a new 'Message' struct instance in the 'addMessage' function instead of modifying the 'LastMsg' struct instance.