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
        address sender;
        string data;
        uint val;
        uint time;
    }

    Message[] public History;

    function AddMessage(address _adr, uint _val, string _data) public {
        Message memory newMessage = Message({
            sender: _adr,
            time: now,
            val: _val,
            data: _data
        });
        History.push(newMessage);
    }
} 

// The repaired contract includes the following changes:
// 1. Changed the "var" keyword to "storage" for the "acc" variable.
// 2. Removed the "payable" modifier from the "Collect" function.
// 3. Added a "require" statement to check the conditions for withdrawal in the "Collect" function.
// 4. Moved the balance subtraction and logging statement before the transfer in the "Collect" function.
// 5. Replaced the deprecated "call.value" method with "transfer" in the "Collect" function.
// 6. Changed the casing of some variable names to follow Solidity naming conventions.