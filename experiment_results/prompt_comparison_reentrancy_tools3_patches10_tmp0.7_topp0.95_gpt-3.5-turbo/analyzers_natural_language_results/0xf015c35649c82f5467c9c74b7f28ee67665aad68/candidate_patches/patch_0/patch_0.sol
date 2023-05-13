pragma solidity ^0.4.25;

contract MY_BANK {
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
        require(acc.balance >= MinSum && acc.balance >= _am && now > acc.unlockTime);
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
    
    function AddMessage(address _adr, uint _val, string _data) public {
        Message memory LastMsg;
        LastMsg.Sender = _adr;
        LastMsg.Time = now;
        LastMsg.Val = _val;
        LastMsg.Data = _data;
        History.push(LastMsg);
    }
} 

// Changes Made:
// 1. Added constructor for MY_BANK contract
// 2. Changed 'var' to 'Holder storage' to specify storage location
// 3. Removed 'payable' from Collect function as it is not necessary
// 4. Added 'require' statement for minimum balance and time lock
// 5. Changed 'call.value' to 'transfer' to prevent re-entrancy vulnerability
// 6. Moved Message struct creation inside AddMessage function to prevent overwriting of previous messages.