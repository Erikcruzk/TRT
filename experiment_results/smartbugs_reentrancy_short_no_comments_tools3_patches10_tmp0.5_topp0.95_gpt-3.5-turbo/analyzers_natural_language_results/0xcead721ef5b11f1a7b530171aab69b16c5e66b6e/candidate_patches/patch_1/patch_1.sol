pragma solidity ^0.4.25;

contract WALLET {
    struct Holder {
        uint unlockTime;
        uint balance;
    }

    mapping (address => Holder) public Acc;
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
        require(acc.balance >= MinSum && acc.balance >= _am && now > acc.unlockTime);
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
        string  Data;
        uint Val;
        uint  Time;
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

// The repaired contract includes the following changes:
// 1. Added the "Holder" struct to define the structure of the account holder.
// 2. Changed the "Put" function to use the "storage" keyword to modify the account holder's balance and unlock time.
// 3. Changed the "Collect" function to use the "require" statement to check if the account holder has sufficient balance and if the unlock time has passed.
// 4. Changed the "Collect" function to use the "transfer" function to send the requested amount to the account holder.
// 5. Added a constructor function to initialize the "LogFile" variable.
// 6. Changed the "AddMessage" function in the "Log" contract to create a new message struct and add it to the "History" array.