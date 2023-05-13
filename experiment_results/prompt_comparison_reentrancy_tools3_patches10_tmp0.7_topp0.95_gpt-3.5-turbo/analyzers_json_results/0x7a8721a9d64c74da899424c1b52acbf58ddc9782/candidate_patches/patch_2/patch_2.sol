pragma solidity ^0.4.19;

contract PrivateDeposit {
    mapping(address => uint) public balances;

    uint public MinDeposit = 1 ether;
    address public owner;

    Log TransferLog;

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    function PrivateDeposit() public {
        owner = msg.sender;
        TransferLog = new Log();
    }

    function setLog(address _lib) public onlyOwner {
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
        Message memory newMessage;
        newMessage.Sender = _adr;
        newMessage.Time = now;
        newMessage.Val = _val;
        newMessage.Data = _data;
        History.push(newMessage);
    }
} 

// Changes Made
// 1. Made all functions public
// 2. Changed require statement in Deposit() to use require instead of if
// 3. Removed the external call from CashOut() and used transfer() instead
// 4. Created a new Message struct in AddMessage() to avoid modifying the LastMsg state variable and causing unintended behavior
// 5. Removed the unused LastMsg state variable and its assignment in AddMessage() function.