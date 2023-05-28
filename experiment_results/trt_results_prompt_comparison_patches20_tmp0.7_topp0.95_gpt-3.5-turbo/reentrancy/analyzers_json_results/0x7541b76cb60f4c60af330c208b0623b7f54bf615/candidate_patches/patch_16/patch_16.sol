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
        Acc[msg.sender].balance += msg.value;
        Acc[msg.sender].unlockTime = _unlockTime > now ? _unlockTime : now;
        LogFile.AddMessage(msg.sender, msg.value, "Put");
    }

    function Collect(uint _am) public {
        require(
            Acc[msg.sender].balance >= MinSum &&
            Acc[msg.sender].balance >= _am &&
            now > Acc[msg.sender].unlockTime
        );

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
        string Data;
        uint Val;
        uint Time;
    }

    Message[] public History;

    function AddMessage(address _adr, uint _val, string _data) public {
        History.push(Message(_adr, _data, _val, now));
    }
}

// The repaired contract ensures the following:
// - The constructor function is used instead of the contract name for initialization.
// - The state variables are declared before the functions.
// - The fallback function only calls the Put function with default value 0.
// - The Collect function has a require statement to ensure the conditions for withdrawing are met.
// - The transfer function is used instead of call.value to prevent reentrancy attacks.