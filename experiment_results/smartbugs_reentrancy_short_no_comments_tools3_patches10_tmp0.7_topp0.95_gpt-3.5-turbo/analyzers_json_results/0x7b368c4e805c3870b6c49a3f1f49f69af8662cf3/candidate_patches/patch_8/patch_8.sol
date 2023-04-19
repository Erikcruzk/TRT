pragma solidity ^0.4.25;

contract W_WALLET {
    struct Holder {
        uint unlockTime;
        uint balance;
    }

    mapping (address => Holder) public Acc;
    Log LogFile;
    uint public MinSum = 1 ether;

    event PutEvent(address indexed sender, uint value, uint unlockTime);
    event CollectEvent(address indexed sender, uint value);

    function W_WALLET(address log) public {
        LogFile = Log(log);
    }

    function put(uint _unlockTime) public payable {
        require(msg.value > 0, "Amount should be greater than 0");
        Holder storage acc = Acc[msg.sender];
        acc.balance += msg.value;
        acc.unlockTime = _unlockTime > now ? _unlockTime : now;
        emit PutEvent(msg.sender, msg.value, acc.unlockTime);
    }

    function collect(uint _am) public {
        Holder storage acc = Acc[msg.sender];
        require(acc.balance >= MinSum, "Balance should be greater than minimum sum");
        require(acc.balance >= _am, "Amount should be less than or equal to balance");
        require(now > acc.unlockTime, "Unlock time has not passed yet");
        acc.balance -= _am;
        emit CollectEvent(msg.sender, _am);
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

    Message[] public History;

    function addMessage(address _adr, uint _val, string _data) public {
        Message memory msg;
        msg.sender = _adr;
        msg.time = now;
        msg.val = _val;
        msg.data = _data;
        History.push(msg);
    }
}