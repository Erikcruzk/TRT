pragma solidity ^0.4.25;

contract W_WALLET {
    mapping(address => Holder) public Acc;
    uint public MinSum = 1 ether;
    Log LogFile;

    struct Holder {
        uint unlockTime;
        uint balance;
    }

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
        string Data;
        uint Val;
        uint Time;
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

// Changes made:
// 1. Moved the mapping declaration to the top of the contract to avoid confusion
// 2. Added a constructor function to initialize the Log contract
// 3. Replaced the 'var' keyword with the actual type 'Holder'
// 4. Replaced the if statement in the Collect function with a require statement to avoid unnecessary nesting
// 5. Moved the Log message creation inside the Collect function to avoid reentrancy issues
// 6. Replaced the external call with a transfer statement in the Collect function to avoid reentrancy issues
// 7. Added a memory keyword to the LastMsg variable in the Log contract to avoid storage errors