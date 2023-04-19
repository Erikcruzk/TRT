pragma solidity ^0.4.25;

contract X_WALLET {
    struct Holder {
        uint unlockTime;
        uint balance;
    }
    
    mapping (address => Holder) public Acc;
    
    Log LogFile;
    
    uint public MinSum = 1 ether;
    
    function X_WALLET(address log) public {
        LogFile = Log(log);
    }
    
    function put(uint _unlockTime) public payable {
        require(msg.value > 0);
        Holder storage acc = Acc[msg.sender];
        acc.balance += msg.value;
        acc.unlockTime = _unlockTime > now ? _unlockTime : now;
        LogFile.addMessage(msg.sender, msg.value, "Put");
    }
    
    function collect(uint _am) public {
        Holder storage acc = Acc[msg.sender];
        require(acc.balance >= MinSum && acc.balance >= _am && now > acc.unlockTime);
        acc.balance -= _am;
        msg.sender.transfer(_am);
        LogFile.addMessage(msg.sender, _am, "Collect");
    }
    
    function() public payable {
        put(0);
    }
}

contract Log {
    struct Message {
        address sender;
        string data;
        uint val;
        uint time;
    }
    
    Message[] public History;
    
    function addMessage(address _adr, uint _val, string _data) public {
        Message memory newMessage;
        newMessage.sender = _adr;
        newMessage.time = now;
        newMessage.val = _val;
        newMessage.data = _data;
        History.push(newMessage);
    }
}