pragma solidity ^0.4.25;

contract W_WALLET {
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
// 1. Added a Holder struct to keep track of unlockTime and balance of each account.
// 2. Replaced the 'var' keyword with 'Holder storage' to avoid unnecessary copies.
// 3. Replaced 'msg.sender.call.value()' with 'msg.sender.transfer()' to avoid reentrancy vulnerabilities.
// 4. Added 'require' statement to check if the account balance is greater than or equal to the minimum sum, and the account balance is greater than or equal to the amount to be collected, and the current time is greater than the unlock time.
// 5. Removed the 'payable' modifier from the Collect function to avoid unnecessary payments.
// 6. Added a constructor function to initialize the LogFile contract.
// 7. Added 'memory' keyword to the LastMsg variable in the AddMessage function to avoid storage-related issues.