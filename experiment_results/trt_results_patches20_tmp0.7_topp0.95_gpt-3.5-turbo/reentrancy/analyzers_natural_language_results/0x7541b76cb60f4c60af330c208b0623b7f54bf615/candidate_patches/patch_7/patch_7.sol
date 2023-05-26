pragma solidity ^0.4.25;

contract U_BANK {
    function Put(uint _unlockTime) public payable {
        Acc[msg.sender].balance += msg.value;
        Acc[msg.sender].unlockTime = _unlockTime > now ? _unlockTime : now;
        LogFile.AddMessage(msg.sender, msg.value, "Put");
    }

    function Collect(uint _am) public {
        var acc = Acc[msg.sender];
        require(acc.balance >= MinSum && acc.balance >= _am && now > acc.unlockTime);
        acc.balance -= _am;
        msg.sender.transfer(_am);
        LogFile.AddMessage(msg.sender, _am, "Collect");
    }

    function() public payable {
        Put(0);
    }

    struct Holder {
        uint unlockTime;
        uint balance;
    }

    mapping(address => Holder) public Acc;

    Log LogFile;

    uint public MinSum = 2 ether;

    constructor(address log) public {
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

    function AddMessage(address _adr, uint _val, string _data) public {
        Message memory newMsg;
        newMsg.Sender = _adr;
        newMsg.Time = now;
        newMsg.Val = _val;
        newMsg.Data = _data;
        History.push(newMsg);
    }
} 

// The repaired contract replaces the call to `msg.sender.call.value(_am)()` with a `msg.sender.transfer(_am)` to prevent reentrancy attacks.
// Additionally, the `require` statement is used to check the conditions for withdrawal, and a new `Message` struct is created in the `AddMessage` function to avoid overwriting the last message.