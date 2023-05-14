pragma solidity ^0.4.25;

contract X_WALLET {
    struct Holder {
        uint unlockTime;
        uint balance;
        bool isInitialized;
    }

    mapping(address => Holder) public Acc;

    Log LogFile;

    uint public MinSum = 1 ether;

    function X_WALLET(address log) public {
        LogFile = Log(log);
    }

    function Put(uint _unlockTime) public payable {
        require(msg.value > 0, "Amount should be greater than 0");
        Holder storage acc = Acc[msg.sender];
        if (!acc.isInitialized) {
            acc.unlockTime = _unlockTime > now ? _unlockTime : now;
            acc.isInitialized = true;
        } else {
            require(now < acc.unlockTime, "Account is locked");
        }
        acc.balance += msg.value;
        LogFile.AddMessage(msg.sender, msg.value, "Put");
    }

    function Collect(uint _am) public {
        Holder storage acc = Acc[msg.sender];
        require(acc.isInitialized, "Account is not initialized");
        require(acc.balance >= MinSum && acc.balance >= _am, "Insufficient balance");
        require(now > acc.unlockTime, "Account is locked");
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

// Changes Made:
// 1. Added a bool flag in Holder struct to check if account is initialized or not.
// 2. In Put function, added a check to see if amount is greater than 0.
// 3. In Put function, added a check to see if account is locked or not.
// 4. In Collect function, removed the payable modifier and replaced the external call with transfer function.
// 5. In Collect function, added a check to see if account is initialized, balance is sufficient and account is not locked.