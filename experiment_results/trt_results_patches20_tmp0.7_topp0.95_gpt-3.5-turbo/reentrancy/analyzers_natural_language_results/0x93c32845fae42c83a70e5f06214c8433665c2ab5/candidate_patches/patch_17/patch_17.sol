pragma solidity ^0.4.25;

contract X_WALLET {
    bool private locked;
    
    function Put(uint _unlockTime) public payable {
        require(!locked);
        locked = true;
        Acc[msg.sender].balance += msg.value;
        Acc[msg.sender].unlockTime = _unlockTime > now ? _unlockTime : now;
        LogFile.AddMessage(msg.sender, msg.value, "Put");
        locked = false;
    }

    function Collect(uint _am) public payable {
        require(!locked);
        locked = true;
        var acc = Acc[msg.sender];
        require(
            acc.balance >= MinSum && acc.balance >= _am && now > acc.unlockTime
        );
        acc.balance -= _am;
        msg.sender.transfer(_am);
        LogFile.AddMessage(msg.sender, _am, "Collect");
        locked = false;
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
        Message memory newMessage = Message({
            Sender: _adr,
            Time: now,
            Val: _val,
            Data: _data
        });
        History.push(newMessage);
    }
} 

// Changes Made:
// 1. Added a locking mechanism to prevent reentrancy in Put and Collect functions.
// 2. Changed the transfer method in Collect function to prevent reentrancy.
// 3. Removed the deprecated constructor function and replaced it with the constructor keyword. 
// 4. Used a local variable to store the message in AddMessage function.