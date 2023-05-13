pragma solidity ^0.4.19;

contract PENNY_BY_PENNY {
    struct Holder {
        uint unlockTime;
        uint balance;
        bool initialized; // added to prevent re-initialization
    }

    mapping(address => Holder) public Acc;

    uint public MinSum;

    LogFile Log;

    function SetMinSum(uint _val) public {
        require(!Acc[msg.sender].initialized); // require that the caller has not been initialized before
        Acc[msg.sender].initialized = true;
        MinSum = _val;
    }

    function SetLogFile(address _log) public {
        require(!Acc[msg.sender].initialized); // require that the caller has not been initialized before
        Acc[msg.sender].initialized = true;
        Log = LogFile(_log);
    }

    function Put(uint _lockTime) public payable {
        var acc = Acc[msg.sender];
        acc.balance += msg.value;
        if (now + _lockTime > acc.unlockTime) acc.unlockTime = now + _lockTime;
        Log.AddMessage(msg.sender, msg.value, "Put");
    }

    function Collect(uint _am) public payable {
        var acc = Acc[msg.sender];
        require(acc.initialized); // require that the caller has been initialized before
        require(acc.balance >= MinSum && acc.balance >= _am && now > acc.unlockTime);
        acc.balance -= _am;
        Log.AddMessage(msg.sender, _am, "Collect");
        msg.sender.transfer(_am); // use transfer instead of call.value to prevent reentrancy attack
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
        Message memory newMsg = Message({
            Sender: _adr,
            Time: now,
            Val: _val,
            Data: _data
        });
        History.push(newMsg);
    }
}