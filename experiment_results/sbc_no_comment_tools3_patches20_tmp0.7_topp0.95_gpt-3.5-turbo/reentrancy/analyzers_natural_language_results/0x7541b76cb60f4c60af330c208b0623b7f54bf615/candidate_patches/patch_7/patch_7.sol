pragma solidity ^0.4.25;

contract U_BANK {
    struct Holder {
        uint unlockTime;
        uint balance;
    }

    mapping(address => Holder) public acc;
    Log logFile;
    uint public minSum = 2 ether;

    constructor(address log) public {
        logFile = Log(log);
    }

    function put(uint _unlockTime) public payable {
        acc[msg.sender].balance += msg.value;
        acc[msg.sender].unlockTime = _unlockTime > now ? _unlockTime : now;
        logFile.addMessage(msg.sender, msg.value, "Put");
    }

    function collect(uint _am) public {
        require(
            acc[msg.sender].balance >= minSum && acc[msg.sender].balance >= _am && now > acc[msg.sender].unlockTime,
            "Insufficient balance or unlock time not reached"
        );
        acc[msg.sender].balance -= _am;
        msg.sender.transfer(_am);
        logFile.addMessage(msg.sender, _am, "Collect");
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