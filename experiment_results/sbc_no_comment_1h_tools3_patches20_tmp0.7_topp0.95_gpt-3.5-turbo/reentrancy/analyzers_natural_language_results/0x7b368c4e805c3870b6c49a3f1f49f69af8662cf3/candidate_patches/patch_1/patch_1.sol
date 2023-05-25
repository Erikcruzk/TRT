pragma solidity ^0.4.25;

contract W_WALLET {
    mapping(address => Holder) public Acc;
    Log public LogFile;
    uint public MinSum = 1 ether;

    struct Holder {
        uint unlockTime;
        uint balance;
    }

    constructor(address log) public {
        LogFile = Log(log);
    }

    function Put(uint _unlockTime) public payable {
        Acc[msg.sender].balance += msg.value;
        Acc[msg.sender].unlockTime = (_unlockTime > now) ? _unlockTime : now;
        LogFile.AddMessage(msg.sender, msg.value, "Put");
    }

    function Collect(uint _am) public {
        Holder storage acc = Acc[msg.sender];
        require(acc.balance >= MinSum && acc.balance >= _am && now > acc.unlockTime);
        acc.balance -= _am;
        require(msg.sender.call.value(_am)());
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
    Message public LastMsg;

    function AddMessage(address _adr, uint _val, string _data) public {
        LastMsg.Sender = _adr;
        LastMsg.Time = now;
        LastMsg.Val = _val;
        LastMsg.Data = _data;
        History.push(LastMsg);
    }
} 

// Changes Made:
// 1. Reordered the contract functions and variables to follow best practices.
// 2. Added 'require' statements for input validation.
// 3. Moved the state variable declarations to the top of the contract.
// 4. Changed the 'var' keyword to 'storage' for explicitness.
// 5. Removed the unnecessary 'payable' modifier from the Collect() function.