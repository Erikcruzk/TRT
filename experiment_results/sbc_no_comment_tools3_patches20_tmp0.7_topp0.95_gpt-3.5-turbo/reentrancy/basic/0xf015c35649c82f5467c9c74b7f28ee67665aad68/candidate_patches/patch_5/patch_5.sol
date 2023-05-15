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
        require(msg.sender.send(_am));
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
        Message memory newMessage;
        newMessage.Sender = _adr;
        newMessage.Time = now;
        newMessage.Val = _val;
        newMessage.Data = _data;
        History.push(newMessage);
    }
} 

// Changes Made:
// 1. Added constructor function instead of using function name as the contract name.
// 2. Added storage keyword to the struct variable.
// 3. Replaced var with storage keyword for better code readability.
// 4. Used require statement for input validation.
// 5. Used send function instead of call.value for secure fund transfer.
// 6. Used memory keyword for newMessage variable in AddMessage function for better optimization and gas usage.