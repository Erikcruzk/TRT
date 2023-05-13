pragma solidity ^0.4.19;

contract PrivateBank {
    mapping(address => uint) public balances;

    uint public MinDeposit = 1 ether;

    Log TransferLog;

    function PrivateBank(address _lib) public {
        TransferLog = new Log();
    }

    function Deposit() public payable {
        if (msg.value >= MinDeposit) {
            balances[msg.sender] += msg.value;
            TransferLog.AddMessage(msg.sender, msg.value, "Deposit");
        }
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
        Message memory newMessage;
        newMessage.Sender = _adr;
        newMessage.Time = now;
        newMessage.Val = _val;
        newMessage.Data = _data;
        History.push(newMessage);
    }
} 

// I have made the following changes to the original contract:
// 1. Added public visibility modifier to constructor of PrivateBank
// 2. Changed the TransferLog variable to be an instance of the Log contract using new keyword instead of passing the address of the Log contract as an argument to the constructor
// 3. Added require statement in CashOut function to check if the requested amount is less than or equal to the balance of the user
// 4. Moved the reduction of the user's balance and the addition of the transaction message to Log contract before the transfer of funds to prevent reentrancy attacks
// 5. Changed the transfer of funds to use the transfer function instead of call.value()() to prevent reentrancy attacks
// 6. Added memory keyword when creating a new Message struct in the AddMessage function of Log contract to prevent storage allocation errors.