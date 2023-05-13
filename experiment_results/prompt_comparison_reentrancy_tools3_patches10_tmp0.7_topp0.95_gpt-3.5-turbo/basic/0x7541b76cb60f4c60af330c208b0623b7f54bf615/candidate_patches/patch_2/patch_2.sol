pragma solidity ^0.4.25;

contract U_BANK {
    
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
// 1. Moved the struct Holder declaration before the mapping Acc to fix the compilation error.
// 2. Added storage keyword to the Holder struct variable in Put() and Collect() functions to specify that it is a storage variable.
// 3. Added a require statement in Collect() function to check if the account has enough balance, minimum balance and if it is unlocked.
// 4. Replaced the call method with transfer method in Collect() function to transfer the amount to the account holder.
// 5. Added memory keyword to the lastMsg variable in AddMessage() function to specify that it is a memory variable. Also, created a new variable lastMsg to store the message and pushed it into the History array.