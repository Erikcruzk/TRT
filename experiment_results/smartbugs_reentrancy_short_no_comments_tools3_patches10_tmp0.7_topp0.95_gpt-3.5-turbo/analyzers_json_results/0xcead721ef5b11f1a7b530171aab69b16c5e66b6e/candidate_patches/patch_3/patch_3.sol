pragma solidity ^0.4.25;

contract WALLET {
    uint public minSum = 1 ether;

    struct Holder {
        uint unlockTime;
        uint balance;
    }

    mapping (address => Holder) public acc;
    Log logFile;

    constructor(address _log) public {
        logFile = Log(_log);
    }

    function put(uint _unlockTime) public payable {
        acc[msg.sender].balance += msg.value;
        acc[msg.sender].unlockTime = _unlockTime > now ? _unlockTime : now;
        logFile.addMessage(msg.sender, msg.value, "Put");
    }

    function collect(uint _am) public {
        Holder storage sender = acc[msg.sender];
        require(sender.balance >= minSum && sender.balance >= _am && now > sender.unlockTime);

        sender.balance -= _am;
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
        string  data;
        uint val;
        uint  time;
    }

    Message[] public history;

    function addMessage(address _adr, uint _val, string _data) public {
        Message memory newMessage = Message({
            sender: _adr,
            time: now,
            val: _val,
            data: _data
        });
        history.push(newMessage);
    }
}