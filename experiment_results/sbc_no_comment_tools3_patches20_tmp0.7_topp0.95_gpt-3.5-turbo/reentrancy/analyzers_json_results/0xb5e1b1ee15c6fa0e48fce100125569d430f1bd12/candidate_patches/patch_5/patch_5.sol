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
        address sender;
        string data;
        uint val;
        uint time;
    }

    Message[] public history;

    function addMessage(address _adr, uint _val, string _data) public {
        Message memory lastMsg = Message(_adr, _data, _val, now);
        history.push(lastMsg);
    }
}

// Changes Made:
// 1. Added the visibility specifier 'public' to the constructor function of Private_Bank.
// 2. Changed the function name 'Deposit' to 'deposit' and modified the if condition to check if the value is greater than or equal to MinDeposit.
// 3. Changed the function name 'CashOut' to 'cashOut' and removed the external call to 'msg.sender.call.value(_am)()', and replaced it with a transfer call to transfer Ether to the msg.sender. Added a require statement to check if the balance is sufficient before transferring Ether. 
// 4. Changed the variable names in the Log contract to follow Solidity naming conventions. 
// 5. Modified the addMessage function in the Log contract to create a new Message struct instance inside the function instead of reusing the LastMsg struct instance.