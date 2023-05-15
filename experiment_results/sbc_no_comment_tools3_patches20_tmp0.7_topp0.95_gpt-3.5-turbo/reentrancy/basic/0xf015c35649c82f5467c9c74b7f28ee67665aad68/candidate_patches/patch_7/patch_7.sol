pragma solidity ^0.4.25;

contract MY_BANK {
    struct Holder {
        uint unlockTime;
        uint balance;
    }

    mapping(address => Holder) public acc;
    uint public minSum = 1 ether;
    Log logFile;

    function MY_BANK(address log) public {
        logFile = Log(log);
    }

    function put(uint _unlockTime) public payable {
        acc[msg.sender].balance += msg.value;
        acc[msg.sender].unlockTime = _unlockTime > now ? _unlockTime : now;
        logFile.addMessage(msg.sender, msg.value, "Put");
    }

    function collect(uint _am) public payable {
        if (acc[msg.sender].balance >= minSum && acc[msg.sender].balance >= _am && now > acc[msg.sender].unlockTime) {
            if (msg.sender.call.value(_am)()) {
                acc[msg.sender].balance -= _am;
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