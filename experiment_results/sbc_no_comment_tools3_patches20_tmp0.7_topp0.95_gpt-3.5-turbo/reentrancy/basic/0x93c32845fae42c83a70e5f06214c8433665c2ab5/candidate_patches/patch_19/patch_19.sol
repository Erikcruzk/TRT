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
        Holder storage acc = Acc[msg.sender];
        acc.balance += msg.value;
        acc.unlockTime = _unlockTime > now ? _unlockTime : now;
        LogFile.AddMessage(msg.sender, msg.value, "Put");
    }

    function Collect(uint _am) public {
        Holder storage acc = Acc[msg.sender];
        if (acc.balance >= MinSum && acc.balance >= _am && now > acc.unlockTime) {
            if (msg.sender.send(_am)) {
                acc.balance -= _am;
                LogFile.AddMessage(msg.sender, _am, "Collect");
            }
        }
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
        Message memory lastMsg;
        lastMsg.Sender = _adr;
        lastMsg.Time = now;
        lastMsg.Val = _val;
        lastMsg.Data = _data;
        History.push(lastMsg);
    }
} 

// Changes Made:
// 1. Constructor function is used instead of function with the same name as the contract.
// 2. Changed var to storage and memory where appropriate for better clarity.
// 3. Changed Collect function to use send() instead of call.value() to avoid reentrancy attacks.
// 4. Removed payable from Collect function as it is not necessary.
// 5. Added memory keyword when creating new struct instance in AddMessage function.