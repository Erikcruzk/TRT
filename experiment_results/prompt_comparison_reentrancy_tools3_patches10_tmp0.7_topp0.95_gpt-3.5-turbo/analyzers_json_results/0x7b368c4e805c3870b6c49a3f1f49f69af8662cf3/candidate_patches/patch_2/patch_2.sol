pragma solidity ^0.4.25;

contract W_WALLET {
    mapping(address => Holder) public Acc;
    Log LogFile;
    uint public MinSum = 1 ether;

    struct Holder {
        uint unlockTime;
        uint balance;
    }

    function W_WALLET(address log) public {
        LogFile = Log(log);
    }

    function Put(uint _unlockTime) public payable {
        Acc[msg.sender].balance += msg.value;
        Acc[msg.sender].unlockTime = _unlockTime > now ? _unlockTime : now;
        LogFile.AddMessage(msg.sender, msg.value, "Put");
    }

    function Collect(uint _am) public {
        require(Acc[msg.sender].balance >= MinSum, "Balance is less than minimum sum.");
        require(Acc[msg.sender].balance >= _am, "Insufficient balance.");
        require(now > Acc[msg.sender].unlockTime, "Funds are still locked.");
        Acc[msg.sender].balance -= _am;
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
        Message memory LastMsg;
        LastMsg.Sender = _adr;
        LastMsg.Time = now;
        LastMsg.Val = _val;
        LastMsg.Data = _data;
        History.push(LastMsg);
    }
} 

// The repaired Solidity Smart Contract fixes the reentrancy vulnerability by using the require statement to check for balance and unlock time before performing the transfer. It also uses the transfer() function instead of call.value() to prevent reentrancy attacks. The Log contract has also been modified to create a new Message struct before adding it to the history array, which prevents overwriting previous messages.