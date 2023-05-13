pragma solidity ^0.4.25;

contract WALLET {
    struct Holder {
        uint unlockTime;
        uint balance;
    }

    mapping(address => Holder) public Acc;

    uint public MinSum = 1 ether;

    Log LogFile;

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
        Message memory msg = Message({
            Sender: _adr,
            Val: _val,
            Data: _data,
            Time: now
        });
        History.push(msg);
    }
} 

// Changes Made:
// 1. Moved the struct Holder above the mapping and MinSum variable
// 2. Removed the payable keyword from the Collect function
// 3. Added a require statement to check if the account balance is greater than or equal to the withdrawal amount, minimum sum and unlock time has passed
// 4. Changed the send function to transfer in the Collect function to prevent reentrancy vulnerability
// 5. Changed the var keyword to storage and memory keywords to improve code readability
// 6. Changed the LogFile.AddMessage() function to create a new Message struct and push it to the History array.