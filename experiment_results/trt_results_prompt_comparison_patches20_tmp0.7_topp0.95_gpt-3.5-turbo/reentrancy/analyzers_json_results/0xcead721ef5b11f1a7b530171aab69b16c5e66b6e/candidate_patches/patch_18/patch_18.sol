pragma solidity ^0.4.25;

contract WALLET {
    mapping(address => Holder) public Acc;
    Log LogFile;
    uint public MinSum = 1 ether;

    struct Holder {
        uint unlockTime;
        uint balance;
        bool isHolder;
    }

    constructor(address log) public {
        LogFile = Log(log);
    }

    function put(uint _unlockTime) public payable {
        require(msg.value > 0, "Cannot deposit 0 ether");
        Holder storage acc = Acc[msg.sender];
        acc.balance += msg.value;
        acc.unlockTime = _unlockTime > now ? _unlockTime : now;
        acc.isHolder = true;
        LogFile.addMessage(msg.sender, msg.value, "Put");
    }

    function collect(uint _am) public {
        Holder storage acc = Acc[msg.sender];
        require(acc.isHolder, "You are not a holder");
        require(acc.balance >= MinSum && acc.balance >= _am && now > acc.unlockTime, "Cannot withdraw");
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
        address Sender;
        string Data;
        uint Val;
        uint Time;
    }

    Message[] public History;

    function addMessage(address _adr, uint _val, string _data) public {
        Message memory msg = Message({
            Sender: _adr,
            Time: now,
            Val: _val,
            Data: _data
        });
        History.push(msg);
    }
}