pragma solidity ^0.4.25;

contract WALLET {
    function Put(uint _unlockTime) public payable {
        var acc = Acc[msg.sender];
        acc.balance += msg.value;
        acc.unlockTime = _unlockTime > now ? _unlockTime : now;
        LogFile.AddMessage(msg.sender, msg.value, "Put");
    }

    function Collect(uint _am) public payable {
        var acc = Acc[msg.sender];
        require(acc.balance >= MinSum && acc.balance >= _am && now > acc.unlockTime); // added require statement
        acc.balance -= _am;
        LogFile.AddMessage(msg.sender, _am, "Collect");
        if (!_safeTransfer(msg.sender, _am)) { // using a separate function to handle transfer
            acc.balance += _am;
        }
    }

    function() public payable {
        Put(0);
    }

    function _safeTransfer(address _to, uint _value) internal returns (bool) { // added a function to handle transfer
        return (_to.call.value(_value)());
    }

    struct Holder {
        uint unlockTime;
        uint balance;
    }

    mapping(address => Holder) public Acc;

    Log LogFile;

    uint public MinSum = 1 ether;

    constructor(address log) public { // changed function name to constructor
        LogFile = Log(log);
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