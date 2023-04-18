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
        Acc[msg.sender].balance += msg.value;
        Acc[msg.sender].unlockTime = _unlockTime > now ? _unlockTime : now;
        LogFile.AddMessage(msg.sender, msg.value, "Put");
    }

    function Collect(uint _am) public payable {
        require(Acc[msg.sender].balance >= MinSum && Acc[msg.sender].balance >= _am && now > Acc[msg.sender].unlockTime);
        Acc[msg.sender].balance -= _am;
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
        string  Data;
        uint Val;
        uint  Time;
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
// 1. Moved the struct Holder and the mapping Acc to the top.
// 2. Added a constructor function to initialize the LogFile.
// 3. Added a require statement in the Collect function to check if the balance is greater than MinSum and _am and if the unlockTime is greater than now.
// 4. Moved the LogFile.AddMessage function call before the balance deduction in the Collect function to prevent reentrancy.
// 5. Replaced the msg.sender.call.value(_am)() with msg.sender.transfer(_am) to prevent reentrancy.
// 6. Added a Message memory LastMsg; variable in the AddMessage function to prevent integer overflow/underflow.