pragma solidity ^0.4.19;

contract MONEY_BOX {
    struct Holder {
        uint unlockTime;
        uint balance;
        bool initialized; // added initialized flag
    }

    mapping(address => Holder) public Acc;

    uint public MinSum;

    Log LogFile;

    function SetMinSum(uint _val) public {
        require(!Acc[msg.sender].initialized); // require that contract is not yet initialized
        MinSum = _val;
    }

    function SetLogFile(address _log) public {
        require(!Acc[msg.sender].initialized); // require that contract is not yet initialized
        LogFile = Log(_log);
    }

    function Initialized() public {
        Acc[msg.sender].initialized = true; // set initialized flag
    }

    function Put(uint _lockTime) public payable {
        var acc = Acc[msg.sender];
        acc.balance += msg.value;
        if (now + _lockTime > acc.unlockTime) acc.unlockTime = now + _lockTime;
        LogFile.AddMessage(msg.sender, msg.value, "Put");
    }

    function Collect(uint _am) public payable {
        var acc = Acc[msg.sender];
        require(
            acc.balance >= MinSum && acc.balance >= _am && now > acc.unlockTime && acc.initialized // require initialized flag
        );
        acc.initialized = false; // reset initialized flag
        acc.balance -= _am;
        msg.sender.transfer(_am); // use transfer instead of call
        LogFile.AddMessage(msg.sender, _am, "Collect");
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

    function AddMessage(address _adr, uint _val, string _data) public {
        Message memory newMessage = Message({
            Sender: _adr,
            Time: now,
            Val: _val,
            Data: _data
        });
        History.push(newMessage);
    }
}