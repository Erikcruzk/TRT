pragma solidity ^0.4.19;

contract PrivateBank {
    mapping(address => uint) public balances;

    uint public minDeposit = 1 ether;

    Log transferLog;

    function PrivateBank(address _lib) public {
        transferLog = Log(_lib);
    }

    function deposit() public payable {
        require(msg.value >= minDeposit);
        balances[msg.sender] += msg.value;
        transferLog.addMessage(msg.sender, msg.value, "Deposit");
    }

    function cashOut(uint _am) public {
        require(_am <= balances[msg.sender]);
        balances[msg.sender] -= _am;
        msg.sender.transfer(_am);
        transferLog.addMessage(msg.sender, _am, "CashOut");
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

// Changes made: 
// 1. Changed function and variable names to use lowerCamelCase
// 2. Added 'public' visibility specifier to functions
// 3. Replaced TransferLog.AddMessage() with transferLog.addMessage()
// 4. Replaced if statements with require statements for input validation
// 5. Removed the external call to msg.sender.call.value() in cashOut() and replaced it with msg.sender.transfer() to prevent reentrancy vulnerability. 
// 6. Added a new message struct in addMessage() to avoid reference type storage issues.