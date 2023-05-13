pragma solidity ^0.4.25;

contract X_Wallet {
    struct Holder {
        uint unlockTime;
        uint balance;
    }

    mapping(address => Holder) public acc;

    Log logFile;

    uint public minSum = 1 ether;

    constructor(address log) public {
        logFile = Log(log);
    }

    function put(uint _unlockTime) public payable {
        Holder storage account = acc[msg.sender];
        account.balance += msg.value;
        account.unlockTime = _unlockTime > now ? _unlockTime : now;
        logFile.addMessage(msg.sender, msg.value, "Put");
    }

    function collect(uint _am) public {
        Holder storage account = acc[msg.sender];
        if (
            account.balance >= minSum && account.balance >= _am && now > account.unlockTime
        ) {
            if (msg.sender.call.value(_am)()) {
                account.balance -= _am;
                logFile.addMessage(msg.sender, _am, "Collect");
            }
        }
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