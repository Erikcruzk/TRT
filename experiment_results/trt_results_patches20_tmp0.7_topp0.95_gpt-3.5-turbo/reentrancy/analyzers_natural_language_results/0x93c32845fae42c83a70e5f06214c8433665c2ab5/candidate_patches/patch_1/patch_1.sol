pragma solidity ^0.4.25;

contract X_WALLET {
    mapping(address => Holder) public Acc;

    Log LogFile;

    uint public MinSum = 1 ether;

    struct Holder {
        uint unlockTime;
        uint balance;
    }

    function X_WALLET(address log) public {
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

    Message LastMsg;

    function AddMessage(address _adr, uint _val, string _data) public {
        LastMsg.Sender = _adr;
        LastMsg.Time = now;
        LastMsg.Val = _val;
        LastMsg.Data = _data;
        History.push(LastMsg);
    }
} 

// The contract has been repaired as follows:
// 1. The reentrancy vulnerability in the Collect function has been fixed by updating the order of operations.
// 2. The reentrancy vulnerability in the Put function has been fixed by moving the call to LogFile.AddMessage to after the state has been updated.
// 3. The visibility of the Collect function has been changed to remove the unnecessary payable modifier.
// 4. The Acc mapping has been moved to the beginning of the contract for better readability.