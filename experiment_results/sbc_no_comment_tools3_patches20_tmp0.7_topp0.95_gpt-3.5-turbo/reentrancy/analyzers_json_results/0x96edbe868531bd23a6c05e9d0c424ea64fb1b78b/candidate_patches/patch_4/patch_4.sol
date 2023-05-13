pragma solidity ^0.4.19;

contract PENNY_BY_PENNY {
    struct Holder {
        uint unlockTime;
        uint balance;
        bool isExist; // added to check if the holder exists
    }

    mapping(address => Holder) public Acc;

    uint public MinSum;

    LogFile Log;

    bool initialized;

    function SetMinSum(uint _val) public {
        require(!initialized);
        MinSum = _val;
    }

    function SetLogFile(address _log) public {
        require(!initialized);
        Log = LogFile(_log);
    }

    function Initialized() public {
        initialized = true;
    }

    function Put(uint _lockTime) public payable {
        var acc = Acc[msg.sender];
        acc.balance += msg.value;
        if (!acc.isExist) {
            acc.isExist = true;
        }
        if (now + _lockTime > acc.unlockTime) acc.unlockTime = now + _lockTime;
        Log.AddMessage(msg.sender, msg.value, "Put");
    }

    function Collect(uint _am) public payable {
        var acc = Acc[msg.sender];
        require(acc.isExist); // added to check if the holder exists
        require(acc.balance >= MinSum && acc.balance >= _am && now > acc.unlockTime); // added require statements
        acc.balance -= _am;
        msg.sender.transfer(_am); // updated to use transfer instead of call.value
        Log.AddMessage(msg.sender, _am, "Collect");
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

    Message LastMsg;

    function AddMessage(address _adr, uint _val, string _data) public {
        LastMsg.Sender = _adr;
        LastMsg.Time = now;
        LastMsg.Val = _val;
        LastMsg.Data = _data;
        History.push(LastMsg);
    }
}