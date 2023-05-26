pragma solidity ^0.4.25;

contract W_WALLET {
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
        Message memory newMsg = Message(_adr, _data, _val, now);
        History.push(newMsg);
    }
} 

// Changes Made:
// 1. Removed 'payable' from Collect function as it does not require any incoming ether.
// 2. Added 'require' statement to check if the user has enough balance and unlock time to collect funds.
// 3. Replaced 'msg.sender.call.value(_am)()' with 'msg.sender.transfer(_am)' to avoid reentrancy vulnerability.
// 4. Changed the type of 'acc' variable in Put and Collect functions to 'storage' to avoid unnecessary gas usage.
// 5. Changed constructor name to 'constructor' as per latest Solidity version. 
// 6. Created a new local variable 'newMsg' in Log contract to avoid overwriting previous logs.