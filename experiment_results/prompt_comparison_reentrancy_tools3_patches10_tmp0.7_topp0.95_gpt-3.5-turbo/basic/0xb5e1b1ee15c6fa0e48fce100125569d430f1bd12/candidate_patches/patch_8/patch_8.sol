pragma solidity ^0.4.19;

contract Private_Bank {
    mapping(address => uint) public balances;

    uint public MinDeposit = 1 ether;

    Log TransferLog;

    function Private_Bank(address _log) public {
        TransferLog = Log(_log);
    }

    function deposit() public payable {
        require(msg.value > MinDeposit);
        balances[msg.sender] += msg.value;
        TransferLog.addMessage(msg.sender, msg.value, "Deposit");
    }

    function cashOut(uint _am) public {
        require(_am <= balances[msg.sender]);
        balances[msg.sender] -= _am;
        require(msg.sender.call.value(_am)());
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
        Message memory newMessage;
        newMessage.Sender = _adr;
        newMessage.Time = now;
        newMessage.Val = _val;
        newMessage.Data = _data;
        History.push(newMessage);
    }
} 

// Changes Made
// 1. Added visibility specifier (public) to Private_Bank constructor.
// 2. Changed function names Deposit and CashOut to deposit and cashOut respectively to follow Solidity naming conventions.
// 3. Reordered the statements in cashOut function to ensure that the balance is updated before the transfer is made.
// 4. Added require statements to ensure that the conditions are met before executing the function.
// 5. Modified the addMessage function to create a new message object instead of modifying the LastMsg object.