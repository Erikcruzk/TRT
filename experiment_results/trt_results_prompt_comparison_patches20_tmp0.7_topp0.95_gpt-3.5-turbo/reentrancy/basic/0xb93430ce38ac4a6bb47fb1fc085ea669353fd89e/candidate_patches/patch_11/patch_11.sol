pragma solidity ^0.4.19;

contract PrivateBank {
    mapping(address => uint) public balances;

    uint public MinDeposit = 1 ether;

    Log TransferLog;

    function PrivateBank(address _lib) public { // Added 'public' to constructor
        TransferLog = new Log(); // Changed to create new instance of Log contract
    }

    function Deposit() public payable {
        require(msg.value >= MinDeposit); // Changed to use 'require' for input validation
        balances[msg.sender] += msg.value;
        TransferLog.AddMessage(msg.sender, msg.value, "Deposit");
    }

    function CashOut(uint _am) public {
        require(_am <= balances[msg.sender]); // Changed to use 'require' for input validation
        require(msg.sender.call.value(_am)()); // Added 'require' to check if transfer was successful
        balances[msg.sender] -= _am;
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
        Message memory newMessage = Message(_adr, _data, _val, now); // Changed to create new struct instance
        History.push(newMessage);
    }
}