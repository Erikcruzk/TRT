pragma solidity ^0.4.19;

contract PENNY_BY_PENNY {
    struct Holder {
        uint unlockTime;
        uint balance;
    }

    mapping(address => Holder) public Acc;

    uint public MinSum;

    LogFile Log;

    bool initialized;

    modifier onlyUninitialized {
        require(!initialized);
        _;
    }

    function SetMinSum(uint _val) public onlyUninitialized {
        MinSum = _val;
    }

    function SetLogFile(address _log) public onlyUninitialized {
        Log = LogFile(_log);
    }

    function Initialized() public {
        initialized = true;
    }

    function Put(uint _lockTime) public payable {
        var acc = Acc[msg.sender];
        acc.balance += msg.value;
        if (now + _lockTime > acc.unlockTime) acc.unlockTime = now + _lockTime;
        Log.AddMessage(msg.sender, msg.value, "Put");
    }

    function Collect(uint _am) public {
        var acc = Acc[msg.sender];
        require(
            acc.balance >= MinSum && acc.balance >= _am && now > acc.unlockTime
        );
        acc.balance -= _am;
        Log.AddMessage(msg.sender, _am, "Collect");
        msg.sender.transfer(_am);
    }

    function() public payable {
        Put(0);
    }
}

contract LogFile {
    struct Message {
        address Sender;
        string Data;
        uint Val;
        uint Time;
    }

    Message[] public History;

    function AddMessage(address _adr, uint _val, string _data) public {
        Message memory lastMsg = Message({
            Sender: _adr,
            Time: now,
            Val: _val,
            Data: _data
        });
        History.push(lastMsg);
    }
}