pragma solidity ^0.4.25;

contract X_Wallet {
    struct Holder {
        uint unlockTime;
        uint balance;
    }

    mapping(address => Holder) public Acc;

    Log LogFile;

    uint public MinSum = 1 ether;

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
        require(acc.balance >= MinSum && acc.balance >= _am && now > acc.unlockTime);
        acc.balance -= _am;
        if (msg.sender.send(_am)) {
            LogFile.addMessage(msg.sender, _am, "Collect");
        } else {
            acc.balance += _am;
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
        Message memory newMessage = Message({
            sender: _adr,
            time: now,
            val: _val,
            data: _data
        });
        history.push(newMessage);
    }
}