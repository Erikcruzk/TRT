pragma solidity ^0.4.25;

contract U_BANK {
    function Put(uint _unlockTime) public payable {
        Holder storage acc = Acc[msg.sender];
        acc.balance += msg.value;
        acc.unlockTime = _unlockTime > now ? _unlockTime : now;
        LogFile.AddMessage(msg.sender, msg.value, "Put");
    }

    function Collect(uint _am) public {
        Holder storage acc = Acc[msg.sender];
        if (
            acc.balance >= MinSum && acc.balance >= _am && now > acc.unlockTime
        ) {
            acc.balance -= _am;
            if (!msg.sender.call.value(_am)()) {
                revert();
            }
            LogFile.AddMessage(msg.sender, _am, "Collect");
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

    Message LastMsg;

    function AddMessage(address _adr, uint _val, string _data) public {
        LastMsg.Sender = _adr;
        LastMsg.Time = now;
        LastMsg.Val = _val;
        LastMsg.Data = _data;
        History.push(LastMsg);
    }
} 

//Changes Made: 
//1. Made the "acc" variable in both Put() and Collect() function as storage type. 
//2. Removed the "payable" modifier from the Collect() function as it was not needed. 
//3. Re-ordered the code inside Collect() function to avoid reentrancy vulnerability. 
//4. Replaced the deprecated constructor syntax with "constructor" keyword.