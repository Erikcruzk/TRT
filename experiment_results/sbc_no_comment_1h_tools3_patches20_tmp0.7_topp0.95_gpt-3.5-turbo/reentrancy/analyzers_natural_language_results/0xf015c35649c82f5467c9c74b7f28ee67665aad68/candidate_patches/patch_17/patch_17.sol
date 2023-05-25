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
        Message memory newMsg = Message({
            Sender: _adr,
            Time: now,
            Val: _val,
            Data: _data
        });
        History.push(newMsg);
    }
} 

// Changes Made:
// 1. Moved the struct Holder and mapping Acc to the top of the contract for better readability
// 2. Added storage keyword to reference the mapping Acc and avoid unnecessary gas costs
// 3. Replaced var with storage to explicitly state the type of the variable and avoid unnecessary gas costs
// 4. Replaced msg.sender.call.value(_am)() with msg.sender.transfer(_am) to prevent reentrancy attack
// 5. Added require statement to check if the balance is sufficient and unlock time has been passed in Collect function
// 6. Replaced the string of LastMsg with a new struct Message to avoid reusing the same variable and to prevent data corruption.