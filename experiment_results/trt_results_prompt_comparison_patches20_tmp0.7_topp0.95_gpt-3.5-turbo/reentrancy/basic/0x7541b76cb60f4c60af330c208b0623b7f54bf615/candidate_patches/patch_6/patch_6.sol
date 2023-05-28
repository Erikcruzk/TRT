pragma solidity ^0.4.25;

contract U_BANK {
    
    struct Holder {
        uint unlockTime;
        uint balance;
    }
    
    mapping(address => Holder) public Acc;
    
    uint public MinSum = 2 ether;
    
    Log LogFile;
    
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
        require(acc.balance >= MinSum && acc.balance >= _am && now > acc.unlockTime, "Insufficient balance or not unlocked yet");
        acc.balance -= _am;
        if (msg.sender.send(_am)) {
            LogFile.AddMessage(msg.sender, _am, "Collect");
        } else {
            acc.balance += _am;
        }
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
        Message memory newMessage = Message({
            Sender: _adr,
            Time: now,
            Val: _val,
            Data: _data
        });
        History.push(newMessage);
    }
}