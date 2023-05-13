pragma solidity ^0.4.19;

contract PENNY_BY_PENNY {
    struct Holder {
        uint unlockTime;
        uint balance;
        bool initialized; // added
    }

    mapping(address => Holder) public Acc;

    uint public MinSum;

    LogFile Log;

    function SetMinSum(uint _val) public {
        require(!Acc[msg.sender].initialized); // modified
        MinSum = _val;
    }

    function SetLogFile(address _log) public {
        require(!Acc[msg.sender].initialized); // modified
        Log = LogFile(_log);
    }

    function Put(uint _lockTime) public payable {
        var acc = Acc[msg.sender];
        if (!acc.initialized) {
            acc.initialized = true;
        }
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
        msg.sender.transfer(_am); // modified
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

    function AddMessage(address _adr, uint _val, string _data) public {
        History.push(Message(_adr, _data, _val, now)); // modified
    }
}