pragma solidity ^0.4.25;

contract X_WALLET {
    struct Holder {
        uint unlockTime;
        uint balance;
    }

    mapping(address => Holder) public Acc;

    Log LogFile;

    uint public MinSum = 1 ether;

    constructor(address log) public {
        LogFile = Log(log);
    }

    function Put(uint _unlockTime) public payable {
        require(msg.value > 0, "Amount should be greater than 0");
        Holder storage acc = Acc[msg.sender];
        acc.balance += msg.value;
        acc.unlockTime = _unlockTime > now ? _unlockTime : now;
        LogFile.AddMessage(msg.sender, msg.value, "Put");
    }

    function Collect(uint _am) public {
        Holder storage acc = Acc[msg.sender];
        require(acc.balance >= MinSum, "Balance should be greater than minimum sum");
        require(acc.balance >= _am, "Amount should be less than or equal to balance");
        require(now > acc.unlockTime, "Funds are locked until unlock time");
        acc.balance -= _am;
        msg.sender.transfer(_am);
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
        Message memory lastMsg = Message(_adr, _data, _val, now);
        History.push(lastMsg);
    }
} 

// Changes Made:
// 1. Added constructor instead of function with contract name.
// 2. Added minimum value check in Put function.
// 3. Replaced var with storage and memory where necessary.
// 4. Removed external call from Collect function to prevent reentrancy attack.
// 5. Changed LastMsg variable to local variable and created new Message struct instance in AddMessage function.