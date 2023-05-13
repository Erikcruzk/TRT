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
        require(
            acc.balance >= MinSum && acc.balance >= _am && now > acc.unlockTime,
            "Insufficient balance or lock time not expired"
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
    Message LastMsg;

    function AddMessage(address _adr, uint _val, string _data) public {
        LastMsg.Sender = _adr;
        LastMsg.Time = now;
        LastMsg.Val = _val;
        LastMsg.Data = _data;
        History.push(LastMsg);
    }
} 

// Changes Made:
// 1. Moved the struct Holder definition to the beginning of the contract to avoid potential issues with the mapping.
// 2. Changed the "var" keyword to "storage" in the Put and Collect functions to specify that the variables are in storage.
// 3. Added a require statement in the Collect function to check if the balance is sufficient and the unlock time has expired.
// 4. Replaced the external call to msg.sender.call.value(_am)() with msg.sender.transfer(_am) to avoid reentrancy vulnerabilities.
// 5. Removed the "payable" modifier from the Collect function as it is not receiving any value.
// 6. Added a constructor function to initialize the LogFile variable.
// 7. Removed the unused "MinSum" variable from the Log contract.