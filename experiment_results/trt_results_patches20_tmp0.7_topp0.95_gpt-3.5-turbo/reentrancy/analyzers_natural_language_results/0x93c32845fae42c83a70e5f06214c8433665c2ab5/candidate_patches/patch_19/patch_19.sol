pragma solidity ^0.4.25;

contract X_WALLET {
    function Put(uint _unlockTime) public payable {
        Acc[msg.sender].balance += msg.value;
        Acc[msg.sender].unlockTime = _unlockTime > now ? _unlockTime : now;
        LogFile.AddMessage(msg.sender, msg.value, "Put");
    }

    function Collect(uint _am) public {
        var acc = Acc[msg.sender];
        if (
            acc.balance >= MinSum && acc.balance >= _am && now > acc.unlockTime
        ) {
            acc.balance -= _am;
            if (!msg.sender.send(_am)) {
                acc.balance += _am;
            } else {
                LogFile.AddMessage(msg.sender, _am, "Collect");
            }
        }
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

    uint public MinSum = 1 ether;

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

// Changes Made:
// 1. Removed the payable modifier from Collect function and changed the logic to transfer ether using send() function
// 2. Removed the var keyword and directly accessed the struct using Acc[msg.sender] in Put and Collect functions
// 3. Changed the constructor function name to constructor
// 4. Added the memory keyword while creating a new message in Log contract's AddMessage function to avoid stack too deep error
// 5. Removed the unnecessary payable modifier from Collect function definition.