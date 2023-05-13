pragma solidity ^0.4.19;

contract MONEY_BOX {
    struct Holder {
        uint unlockTime;
        uint balance;
        bool initialized;
    }

    mapping(address => Holder) public Acc;

    uint public MinSum;

    Log LogFile;

    function setMinSum(uint _val) public {
        require(!Acc[msg.sender].initialized);
        MinSum = _val;
        Acc[msg.sender].initialized = true;
    }

    function setLogFile(address _log) public {
        require(!Acc[msg.sender].initialized);
        LogFile = Log(_log);
        Acc[msg.sender].initialized = true;
    }

    function put(uint _lockTime) public payable {
        var acc = Acc[msg.sender];
        acc.balance += msg.value;
        if (now + _lockTime > acc.unlockTime) acc.unlockTime = now + _lockTime;
        LogFile.addMessage(msg.sender, msg.value, "Put");
    }

    function collect(uint _am) public {
        var acc = Acc[msg.sender];
        require(
            acc.balance >= MinSum && acc.balance >= _am && now > acc.unlockTime
        );
        acc.balance -= _am;
        require(msg.sender.call.value(_am)());
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
        Message memory lastMsg;
        lastMsg.Sender = _adr;
        lastMsg.Time = now;
        lastMsg.Val = _val;
        lastMsg.Data = _data;
        History.push(lastMsg);
    }
}