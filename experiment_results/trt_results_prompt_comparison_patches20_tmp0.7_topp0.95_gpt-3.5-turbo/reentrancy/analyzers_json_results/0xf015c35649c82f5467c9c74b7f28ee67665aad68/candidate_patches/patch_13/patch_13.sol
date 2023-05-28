pragma solidity ^0.4.25;

contract MY_BANK {
    mapping(address => Holder) public Acc;
    Log public LogFile;
    uint public MinSum = 1 ether;

    struct Holder {
        uint unlockTime;
        uint balance;
        bool isExist;
    }

    function MY_BANK(address log) public {
        LogFile = Log(log);
    }

    function put(uint _unlockTime) public payable {
        Holder storage acc = Acc[msg.sender];
        acc.balance += msg.value;
        acc.unlockTime = _unlockTime > now ? _unlockTime : now;
        LogFile.addMessage(msg.sender, msg.value, "Put");
        acc.isExist = true;
    }

    function collect(uint _am) public payable {
        Holder storage acc = Acc[msg.sender];
        require(acc.isExist);
        require(acc.balance >= MinSum && acc.balance >= _am && now > acc.unlockTime);
        acc.balance -= _am;
        LogFile.addMessage(msg.sender, _am, "Collect");
        msg.sender.transfer(_am);
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

    Message[] public History;

    function addMessage(address _adr, uint _val, string _data) public {
        Message memory msg = Message(_adr, _data, _val, now);
        History.push(msg);
    }
}