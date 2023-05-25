pragma solidity ^0.4.25;

contract WALLET {
    mapping(address => Holder) private Acc;
    Log private LogFile;
    uint public MinSum = 1 ether;

    struct Holder {
        uint unlockTime;
        uint balance;
    }

    function WALLET(address log) public {
        LogFile = Log(log);
    }

    function Put(uint _unlockTime) public payable {
        Acc[msg.sender].balance += msg.value;
        Acc[msg.sender].unlockTime = _unlockTime > now ? _unlockTime : now;
        LogFile.AddMessage(msg.sender, msg.value, "Put");
    }

    function Collect(uint _am) public {
        Holder storage acc = Acc[msg.sender];
        require(acc.balance >= MinSum && acc.balance >= _am && now > acc.unlockTime, "Insufficient balance or locked funds");
        acc.balance -= _am;
        LogFile.AddMessage(msg.sender, _am, "Collect");
        require(msg.sender.call.value(_am)(), "Transfer failed");
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

    Message[] private History;
    Message private LastMsg;

    function AddMessage(address _adr, uint _val, string _data) public {
        LastMsg.Sender = _adr;
        LastMsg.Time = now;
        LastMsg.Val = _val;
        LastMsg.Data = _data;
        History.push(LastMsg);
    }
}

// Changes Made:
// 1. Made the Acc mapping private to prevent external access
// 2. Added require statements to check for sufficient balance and unlocked funds in the Collect function
// 3. Moved the LogFile.AddMessage call to after the state changes in the Collect function to prevent reentrancy
// 4. Removed the payable modifier from the Collect function to prevent accidental transfers
// 5. Made the History and LastMsg variables private to prevent external access