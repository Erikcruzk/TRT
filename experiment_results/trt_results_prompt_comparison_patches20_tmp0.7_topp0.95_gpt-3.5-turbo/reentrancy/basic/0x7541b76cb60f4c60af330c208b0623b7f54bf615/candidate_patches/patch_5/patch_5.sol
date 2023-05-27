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
        require(acc.balance >= MinSum && acc.balance >= _am && now > acc.unlockTime, "Insufficient balance or unlock time not reached");
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

    function AddMessage(address _adr, uint _val, string _data) public {
        Message memory LastMsg = Message({
            Sender: _adr,
            Time: now,
            Val: _val,
            Data: _data
        });
        History.push(LastMsg);
    }
} 

// Changes Made:
// 1. Moved the struct Holder to the top of the contract.
// 2. Changed the constructor name to `constructor`.
// 3. Added `storage` keyword to `acc` variable in functions Put and Collect.
// 4. Added `require` statement in Collect function to check if the balance is sufficient and unlock time is reached.
// 5. Moved the addition of message to Log contract after the transfer of funds in Collect function.
// 6. Changed LastMsg variable from storage to memory in AddMessage function of Log contract.