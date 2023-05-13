pragma solidity ^0.4.25;

contract WALLET {
    struct Holder {
        uint unlockTime;
        uint balance;
    }

    mapping(address => Holder) public Acc;
    Log LogFile;
    uint public MinSum = 1 ether;

    function WALLET(address log) public {
        LogFile = Log(log);
    }

    function Put(uint _unlockTime) public payable {
        Acc[msg.sender].balance += msg.value;
        Acc[msg.sender].unlockTime = _unlockTime > now ? _unlockTime : now;
        LogFile.AddMessage(msg.sender, msg.value, "Put");
    }

    function Collect(uint _am) public {
        Holder storage acc = Acc[msg.sender];
        require(
            acc.balance >= MinSum && acc.balance >= _am && now > acc.unlockTime,
            "Insufficient balance or unlock time not reached"
        );
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
        Message memory newMsg;
        newMsg.Sender = _adr;
        newMsg.Time = now;
        newMsg.Val = _val;
        newMsg.Data = _data;
        History.push(newMsg);
    }
} 

// Changes Made:
// 1. Removed the 'var' keyword and used 'Holder storage acc' instead to explicitly state the storage type.
// 2. Replaced the external call with 'msg.sender.transfer(_am)' to avoid reentrancy vulnerability.
// 3. Added a 'require' statement to check for sufficient balance and unlock time.
// 4. Changed the 'LogFile' variable to a state variable instead of being declared inside a function.
// 5. Changed 'LastMsg' variable to a memory variable and created a new instance of 'Message' struct to avoid overwriting previous values.