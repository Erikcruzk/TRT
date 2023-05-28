pragma solidity ^0.4.25;

contract X_WALLET {
    mapping(address => Holder) public Acc;
    uint public MinSum = 1 ether;
    Log LogFile;

    struct Holder {
        uint unlockTime;
        uint balance;
        bool isExists;
    }

    function X_WALLET(address log) public {
        LogFile = Log(log);
    }

    function Put(uint _unlockTime) public payable {
        Holder storage acc = Acc[msg.sender];
        acc.balance += msg.value;
        acc.unlockTime = _unlockTime > now ? _unlockTime : now;
        acc.isExists = true;
        LogFile.AddMessage(msg.sender, msg.value, "Put");
    }

    function Collect(uint _am) public payable {
        Holder storage acc = Acc[msg.sender];
        require(acc.isExists && acc.balance >= MinSum && acc.balance >= _am && now > acc.unlockTime);
        acc.balance -= _am;
        if (msg.sender.call.value(_am)()) {
            LogFile.AddMessage(msg.sender, _am, "Collect");
        } else {
            acc.balance += _am;
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
    Message LastMsg;

    function AddMessage(address _adr, uint _val, string _data) public {
        LastMsg.Sender = _adr;
        LastMsg.Time = now;
        LastMsg.Val = _val;
        LastMsg.Data = _data;
        History.push(LastMsg);
    }
} 

// Changes made:
// 1. Added a flag in the Holder struct to check if the account exists.
// 2. Added require statements to check if the account exists and the conditions for withdrawal are met.
// 3. Moved the balance deduction before the external call to prevent reentrancy attacks.
// 4. Added a check to revert the balance deduction if the external call fails.