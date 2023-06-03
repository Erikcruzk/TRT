pragma solidity ^0.4.25;

contract U_BANK {
    mapping(address => Holder) public Acc;

    Log LogFile;

    uint public MinSum = 2 ether;

    struct Holder {
        uint unlockTime;
        uint balance;
    }

    function U_BANK(address log) public {
        LogFile = Log(log);
    }

    function Put(uint _unlockTime) public payable {
        Acc[msg.sender].balance += msg.value;
        Acc[msg.sender].unlockTime = _unlockTime > now ? _unlockTime : now;
        LogFile.AddMessage(msg.sender, msg.value, "Put");
    }

    function Collect(uint _am) public {
        require(_am > 0);
        var acc = Acc[msg.sender];
        require(acc.balance >= MinSum && acc.balance >= _am && now > acc.unlockTime);
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

// This Solidity Smart Contract has been repaired to prevent reentrancy vulnerability in Collect function. The changes made:
// 1. Removed the payable modifier from Collect function as it is not required.
// 2. Added require statements to validate input parameters and prevent underflow.
// 3. Moved the balance deduction statement before the external call to prevent reentrancy attacks.
// 4. Replaced the external call with transfer statement to prevent reentrancy attacks.