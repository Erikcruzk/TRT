pragma solidity ^0.4.25;

contract MY_BANK {
    mapping(address => Holder) public Acc;

    Log LogFile;

    uint public MinSum = 1 ether;

    struct Holder {
        uint unlockTime;
        uint balance;
    }

    function MY_BANK(address log) public {
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
        Message memory newMessage = Message(_adr, _data, _val, now);
        History.push(newMessage);
    }
} 

// Changes Made:
// 1. Moved the struct and mapping declaration before the functions.
// 2. Removed the "var" keyword and used "storage" instead while accessing the mapping.
// 3. Added "require" statement to check if the conditions are met before collecting the amount.
// 4. Changed "msg.sender.call.value(_am)()" to "msg.sender.transfer(_am)" to transfer the amount to the sender.
// 5. Used "memory" instead of "storage" while creating a new Message object in the Log contract's AddMessage function.