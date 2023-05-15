pragma solidity ^0.4.25;

contract W_WALLET {
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
        Message memory newMsg = Message({
            Sender: _adr,
            Time: now,
            Val: _val,
            Data: _data
        });
        History.push(newMsg);
    }
} 

/* Changes made:
- Moved the struct Holder to the top and changed the keyword "var" to "storage" in functions Put and Collect to specify that we want to modify the storage state instead of the memory state.
- Added a constructor to initialize the LogFile variable.
- Replaced the if statement with a require statement in function Collect to ensure that the required conditions are met before the function is executed.
- Replaced the call.value() syntax with the transfer() function in function Collect to prevent reentrancy attacks.
- Changed the LogFile.AddMessage() function in function Put to use the correct order of parameters.
- Changed the LogFile.AddMessage() function in contract Log to create a new message instead of modifying the LastMsg variable, which was causing all messages to be the same. */