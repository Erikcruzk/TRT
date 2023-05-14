pragma solidity ^0.4.25;

contract MY_BANK {
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
        require(
            acc.balance >= MinSum && acc.balance >= _am && now > acc.unlockTime,
            "Invalid balance or unlock time"
        );
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
        Message memory lastMsg = Message(_adr, _data, _val, now);
        History.push(lastMsg);
    }
} 

// Changes made:
// 1. Moved the struct Holder above the mapping and made it storage instead of memory to prevent reentrancy vulnerability.
// 2. Removed the "payable" modifier from the Collect function as it does not receive any funds.
// 3. Added a "require" statement to check for valid balance and unlock time in the Collect function.
// 4. Replaced the "call.value" method with "transfer" to prevent reentrancy vulnerability.
// 5. Changed the constructor function to "constructor" as the "function" keyword is deprecated.
// 6. Changed the way the AddMessage function adds messages to the History array to prevent a bug where all messages in the array would be the same.