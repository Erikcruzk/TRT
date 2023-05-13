pragma solidity ^0.4.25;

contract U_BANK {
    struct Holder {
        uint unlockTime;
        uint balance;
    }

    mapping(address => Holder) public Acc;

    Log LogFile;

    uint public MinSum = 2 ether;

    constructor(address log) public {
        LogFile = Log(log);
    }

    function put(uint _unlockTime) public payable {
        Holder storage acc = Acc[msg.sender];
        acc.balance += msg.value;
        acc.unlockTime = _unlockTime > now ? _unlockTime : now;
        LogFile.addMessage(msg.sender, msg.value, "Put");
    }

    function collect(uint _am) public {
        Holder storage acc = Acc[msg.sender];
        require(
            acc.balance >= MinSum && acc.balance >= _am && now > acc.unlockTime,
            "Insufficient balance or locked funds"
        );
        acc.balance -= _am;
        msg.sender.transfer(_am);
        LogFile.addMessage(msg.sender, _am, "Collect");
    }

    function() public payable {
        put(0);
    }
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
// - Renamed functions to follow Solidity naming conventions
// - Added explicit visibility modifiers to functions and variables
// - Used the "transfer" function instead of "call.value" to prevent reentrancy vulnerability
// - Added error messages to "require" statements to provide better feedback to users
// - Changed the "var" keyword to "storage" for clarity and to avoid potential issues
// - Added a local variable in the "addMessage" function to prevent overwriting previous messages in the "history" array