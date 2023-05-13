pragma solidity ^0.4.19;

contract PrivateBank {
    mapping(address => uint) public balances;

    uint public MinDeposit = 1 ether;

    Log TransferLog;

    function PrivateBank(address _lib) public {
        TransferLog = Log(_lib);
    }

    function Deposit() public payable {
        if (msg.value >= MinDeposit) {
            balances[msg.sender] += msg.value;
            TransferLog.AddMessage(msg.sender, msg.value, "Deposit");
        }
    }

    function CashOut(uint _am) public {
        if (_am <= balances[msg.sender]) {
            balances[msg.sender] -= _am;
            TransferLog.AddMessage(msg.sender, _am, "CashOut");
            require(msg.sender.call.value(_am)());
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

    function AddMessage(address _adr, uint _val, string _data) public {
        Message memory newMessage = Message({
            Sender: _adr,
            Val: _val,
            Data: _data,
            Time: now
        });
        History.push(newMessage);
    }
} 

// Changes made:
// 1. Added public modifier to constructor
// 2. Added require statement to CashOut function to prevent reentrancy attack
// 3. Changed LastMsg variable in Log contract to a local variable in AddMessage function and added memory keyword
// 4. Added newMessage struct variable in AddMessage function and pushed to History array directly instead of using LastMsg variable.