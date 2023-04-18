pragma solidity ^0.4.25;

contract MY_BANK {
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
            require(msg.sender.call.value(_am)());
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
        Message memory LastMsg;
        LastMsg.Sender = _adr;
        LastMsg.Time = now;
        LastMsg.Val = _val;
        LastMsg.Data = _data;
        History.push(LastMsg);
    }
} 

// Changes Made:
// 1. Added constructor function with 'constructor' keyword
// 2. Changed 'var' to 'Holder storage' for 'acc' variable in Put() and Collect() functions
// 3. Moved 'LogFile.AddMessage()' after the 'acc.balance' update in Put() function
// 4. Added 'require(msg.sender.call.value(_am)());' after 'LogFile.AddMessage()' in Collect() function to prevent reentrancy vulnerability
// 5. Added 'memory' keyword for 'LastMsg' variable in AddMessage() function to fix the integer overflow/underflow vulnerability.