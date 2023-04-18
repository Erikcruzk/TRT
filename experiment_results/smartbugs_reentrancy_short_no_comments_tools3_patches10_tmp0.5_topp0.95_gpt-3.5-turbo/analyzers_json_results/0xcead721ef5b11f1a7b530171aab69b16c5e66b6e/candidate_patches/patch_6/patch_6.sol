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
        if (acc.balance >= MinSum && acc.balance >= _am && now > acc.unlockTime) {
            acc.balance -= _am;
            LogFile.AddMessage(msg.sender, _am, "Collect");
            require(msg.sender.send(_am));
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
        Message memory newMessage;
        newMessage.Sender = _adr;
        newMessage.Time = now;
        newMessage.Val = _val;
        newMessage.Data = _data;
        History.push(newMessage);
    }
} 

// Changes Made:
// 1. Added constructor function to initialize LogFile variable.
// 2. Changed the storage type of acc from memory to storage in both Put and Collect functions.
// 3. Removed the payable modifier from Collect function.
// 4. Moved the balance deduction and LogFile.AddMessage function call before the external call in Collect function.
// 5. Replaced the var keyword with the explicit storage type declaration. 
// 6. Added memory keyword to the Message struct declaration in Log contract.
// 7. Created a new Message struct in AddMessage function before adding it to the History array.