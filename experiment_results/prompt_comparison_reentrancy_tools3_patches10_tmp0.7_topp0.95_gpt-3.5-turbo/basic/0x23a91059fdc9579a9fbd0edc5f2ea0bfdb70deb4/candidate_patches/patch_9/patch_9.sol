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
        require(msg.sender.call.value(_am)());
        TransferLog.addMessage(msg.sender, _am, "CashOut");
    }

    function() public payable {}

}

contract Log {
    struct Message {
        address sender;
        string data;
        uint val;
        uint time;
    }

    Message[] public history;

    function addMessage(address _adr, uint _val, string _data) public {
        Message memory lastMsg;
        lastMsg.sender = _adr;
        lastMsg.time = now;
        lastMsg.val = _val;
        lastMsg.data = _data;
        history.push(lastMsg);
    }
} 

//Changes Made:
//1. Added the visibility modifier public to the constructor of the PrivateBank contract.
//2. Changed the function names Deposit and CashOut to deposit and cashOut respectively to follow the naming convention.
//3. Added the require statement in the deposit and cashOut functions to check if the condition is true, otherwise the function will not execute and the gas will be returned.
//4. Added a memory keyword before the struct variable lastMsg in the addMessage function of the Log contract. This is because structs are not stored in storage by default and need to be explicitly defined as memory variables.
//5. Removed the unnecessary LastMsg variable in the Log contract and replaced it with a local variable lastMsg in the addMessage function.