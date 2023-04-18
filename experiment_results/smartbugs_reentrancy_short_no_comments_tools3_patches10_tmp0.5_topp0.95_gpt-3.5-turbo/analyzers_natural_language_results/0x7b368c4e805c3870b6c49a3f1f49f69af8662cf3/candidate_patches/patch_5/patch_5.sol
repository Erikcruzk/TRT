pragma solidity ^0.4.25;

contract W_WALLET {
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
        Acc[msg.sender].balance += msg.value;
        Acc[msg.sender].unlockTime = _unlockTime > now ? _unlockTime : now;
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
        Message memory msg = Message(_adr, _data, _val, now);
        History.push(msg);
    }
} 

// Changes Made:
// 1. Moved the struct Holder and mapping Acc above the function declarations.
// 2. Added constructor to initialize LogFile.
// 3. Added require statement to check if the balance is sufficient and unlock time is over in Collect function.
// 4. Moved the balance subtraction and LogFile.AddMessage() above the external call in Collect function.
// 5. Replaced external call with transfer in Collect function.
// 6. Changed var to Holder storage in Collect function.
// 7. Removed payable modifier from Collect function.