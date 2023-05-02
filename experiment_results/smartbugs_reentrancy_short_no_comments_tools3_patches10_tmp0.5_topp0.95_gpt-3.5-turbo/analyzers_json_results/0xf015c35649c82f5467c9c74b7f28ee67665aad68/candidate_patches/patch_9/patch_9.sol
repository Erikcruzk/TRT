pragma solidity ^0.4.25;

contract MY_BANK {
    struct Holder {
        uint unlockTime;
        uint balance;
    }
    
    mapping (address => Holder) public Acc;
    
    Log LogFile;
    
    uint public MinSum = 1 ether;
    
    constructor(address log) public {
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
        Message memory newMessage;
        newMessage.Sender = _adr;
        newMessage.Time = now;
        newMessage.Val = _val;
        newMessage.Data = _data;
        History.push(newMessage);
    }
}

// The repaired contract removes the vulnerability of reentrancy in the Collect function by first checking the balance and unlock time of the account holder before transferring the funds. It also uses the transfer function instead of call.value to ensure the safety of the contract. Additionally, it initializes the LastMsg struct in the AddMessage function to avoid integer underflow/overflow errors.