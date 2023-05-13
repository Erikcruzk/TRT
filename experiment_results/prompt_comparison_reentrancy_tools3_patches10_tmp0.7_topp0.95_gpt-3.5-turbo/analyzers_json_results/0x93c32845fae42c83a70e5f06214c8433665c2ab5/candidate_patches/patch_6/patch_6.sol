pragma solidity ^0.4.25;

contract X_WALLET {
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
        require(acc.balance >= MinSum && acc.balance >= _am && now > acc.unlockTime, "Insufficient balance or unlock time not reached");
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
    Message LastMsg;

    function AddMessage(address _adr, uint _val, string _data) public {
        LastMsg.Sender = _adr;
        LastMsg.Time = now;
        LastMsg.Val = _val;
        LastMsg.Data = _data;
        History.push(LastMsg);
    }
} 

// Changes made:
// - Changed the contract name to match the file name
// - Added the "storage" keyword to the "acc" variable in Put() and Collect() functions to explicitly specify storage access
// - Replaced the "var" keyword with "Holder storage" to explicitly specify the data type of the "acc" variable
// - Removed the "payable" keyword from the Collect() function as it is not necessary since the function does not receive any Ether
// - Added a "require" statement in the Collect() function to check if the balance is sufficient and the unlock time has passed
// - Replaced the "call" function with "transfer" in the Collect() function to prevent reentrancy attacks
// - Moved the struct and mapping declarations to the top of the contract
// - Changed the constructor name to "constructor" instead of using the contract name
// - Removed the unused "msg.value" parameter from the Collect() function
// - Added error messages to the "require" statement in the Collect() function to provide more information to the user when the transaction fails.