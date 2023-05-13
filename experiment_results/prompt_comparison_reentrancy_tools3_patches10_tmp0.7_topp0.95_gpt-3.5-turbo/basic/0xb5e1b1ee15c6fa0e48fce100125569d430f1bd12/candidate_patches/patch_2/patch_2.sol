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
        Message memory lastMsg = Message({
            Sender: _adr,
            Time: now,
            Val: _val,
            Data: _data
        });
        History.push(lastMsg);
    }
} 

//Changes made:
//1. Added public keyword to the constructor of Private_Bank contract.
//2. Changed the function names to follow Solidity naming convention (Deposit to deposit and CashOut to cashOut).
//3. Added require statements to check conditions and revert the transaction if they are not met.
//4. Removed unnecessary if statement in deposit function.
//5. Changed the name of addMessage function to follow Solidity naming convention (addMessage to addMessage).
//6. Modified the way struct Message is created to avoid reusing the same struct variable.