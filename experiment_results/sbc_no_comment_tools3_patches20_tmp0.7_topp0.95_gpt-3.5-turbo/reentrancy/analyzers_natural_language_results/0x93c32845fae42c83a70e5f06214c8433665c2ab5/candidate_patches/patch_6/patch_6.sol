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
        Message memory LastMsg;
        LastMsg.Sender = _adr;
        LastMsg.Time = now;
        LastMsg.Val = _val;
        LastMsg.Data = _data;
        History.push(LastMsg);
    }
} 

// Changes Made:
// 1. Added struct Holder inside contract X_WALLET.
// 2. Changed Acc[msg.sender] to Holder storage acc = Acc[msg.sender] for better readability and security.
// 3. Removed payable from Collect() function.
// 4. Added require() for better security to check if the balance is greater than MinSum and _am and current time is greater than unlockTime.
// 5. Moved balance subtraction and LogFile.AddMessage() above the transfer() to avoid reentrancy vulnerability.
// 6. Changed msg.sender.call.value(_am)() to msg.sender.transfer(_am) for better security.
// 7. Removed var keyword. 
// 8. Added memory to LastMsg in Log contract to avoid stack too deep error.