pragma solidity ^0.4.19;

contract PrivateBank {
    mapping(address => uint) public balances;

    uint public MinDeposit = 1 ether;

    Log TransferLog;

    function PrivateBank(address _lib) public {
        TransferLog = new Log();
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
        Message memory newMessage = Message({
            Sender: _adr,
            Time: now,
            Val: _val,
            Data: _data
        });
        History.push(newMessage);
    }
} 

// Changes:
// 1. Added missing visibility specifier "public" to PrivateBank constructor
// 2. Replaced TransferLog library with a new instance of the Log contract
// 3. Replaced if statement with require statement in Deposit function
// 4. Removed if statement and added require statement in CashOut function
// 5. Replaced call.value()() with transfer() in CashOut function
// 6. Removed unused LastMsg variable in Log contract
// 7. Changed AddMessage function to create a new Message struct and push it to the History array directly.