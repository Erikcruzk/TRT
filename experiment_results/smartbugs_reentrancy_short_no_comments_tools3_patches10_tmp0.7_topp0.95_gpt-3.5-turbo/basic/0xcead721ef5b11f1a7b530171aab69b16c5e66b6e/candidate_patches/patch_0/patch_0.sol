pragma solidity ^0.4.25;

contract Wallet {
    struct Holder {
        uint unlockTime;
        uint balance;
    }

    mapping (address => Holder) public accounts;
    uint public minSum = 1 ether;
    Log logFile;

    constructor(address log) public {
        logFile = Log(log);
    }

    function put(uint _unlockTime) public payable {
        Holder storage acc = accounts[msg.sender];
        acc.balance += msg.value;
        acc.unlockTime = _unlockTime > now ? _unlockTime : now;
        logFile.addMessage(msg.sender, msg.value, "Put");
    }

    function collect(uint _am) public payable {
        Holder storage acc = accounts[msg.sender];
        require(acc.balance >= minSum && acc.balance >= _am && now > acc.unlockTime);
        acc.balance -= _am;
        logFile.addMessage(msg.sender, _am, "Collect");
        msg.sender.transfer(_am);
    }

    function() public payable {
        put(0);
    }
}

contract Log {
    struct Message {
        address sender;
        string  data;
        uint val;
        uint  time;
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