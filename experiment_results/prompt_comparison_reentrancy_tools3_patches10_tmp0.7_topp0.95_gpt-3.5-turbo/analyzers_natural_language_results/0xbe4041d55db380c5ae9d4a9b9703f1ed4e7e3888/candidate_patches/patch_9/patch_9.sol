pragma solidity ^0.4.19;

contract MONEY_BOX {
    struct Holder {
        uint unlockTime;
        uint balance;
    }

    mapping(address => Holder) public Acc;

    uint public MinSum;

    Log LogFile;

    bool intitalized;

    function SetMinSum(uint _val) public {
        require(!intitalized); // use require instead of throw
        MinSum = _val;
    }

    function SetLogFile(address _log) public {
        require(!intitalized); // use require instead of throw
        LogFile = Log(_log);
    }

    function Initialized() public {
        intitalized = true;
    }

    function Put(uint _lockTime) public payable {
        var acc = Acc[msg.sender];
        acc.balance += msg.value;
        if (now + _lockTime > acc.unlockTime) acc.unlockTime = now + _lockTime;
        LogFile.AddMessage(msg.sender, msg.value, "Put");
    }

    function Collect(uint _am) public {
        var acc = Acc[msg.sender];
        require(
            acc.balance >= MinSum && acc.balance >= _am && now > acc.unlockTime
        ); // use require instead of if statement
        acc.balance -= _am;
        LogFile.AddMessage(msg.sender, _am, "Collect");
        msg.sender.transfer(_am); // transfer the amount after the state changes
    }

    function() public payable {
        Put(0);
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

    Message LastMsg;

    function AddMessage(address _adr, uint _val, string _data) public {
        LastMsg.Sender = _adr;
        LastMsg.Time = now;
        LastMsg.Val = _val;
        LastMsg.Data = _data;
        History.push(LastMsg);
    }
}