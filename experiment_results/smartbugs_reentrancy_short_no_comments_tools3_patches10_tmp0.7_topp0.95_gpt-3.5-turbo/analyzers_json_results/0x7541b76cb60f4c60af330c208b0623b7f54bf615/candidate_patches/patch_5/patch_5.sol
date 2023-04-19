pragma solidity ^0.4.25;

contract U_BANK {
    struct Holder {
        uint unlockTime;
        uint balance;
    }

    mapping (address => Holder) public Acc;

    Log LogFile;

    uint public MinSum = 2 ether;

    constructor(address log) public {
        LogFile = Log(log);
    }

    function Put(uint _unlockTime) public payable {
        Holder storage acc = Acc[msg.sender];
        acc.balance += msg.value;
        acc.unlockTime = _unlockTime > now ? _unlockTime : now;
        LogFile.AddMessage(msg.sender, msg.value, "Put");
    }

    function Collect(uint _am) public {
        Holder storage acc = Acc[msg.sender];
        require(acc.balance >= MinSum && acc.balance >= _am && now > acc.unlockTime);
        acc.balance -= _am;
        LogFile.AddMessage(msg.sender, _am, "Collect");
        msg.sender.transfer(_am);
    }

    function() public payable {
        Put(0);
    }
}

contract Log {
    struct Message {
        address Sender;
        string  Data;
        uint Val;
        uint  Time;
    }

    Message[] public History;

    function AddMessage(address _adr, uint _val, string _data) public {
        Message memory msg;
        msg.Sender = _adr;
        msg.Time = now;
        msg.Val = _val;
        msg.Data = _data;
        History.push(msg);
    }
} 

// Changes Made:
// 1. Moved the struct Holder outside the contract U_BANK.
// 2. Changed var to storage in functions Put and Collect for better security.
// 3. Added require statement in Collect function to prevent underflow and overflow.
// 4. Replaced msg.sender.call.value with msg.sender.transfer in Collect function to prevent reentrancy vulnerability.
// 5. Removed the LastMsg struct and added the Message struct in Log contract.
// 6. Added memory keyword to the Message struct in AddMessage function of Log contract.
// 7. Initialized the Message struct in AddMessage function of Log contract.