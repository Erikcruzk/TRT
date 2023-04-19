pragma solidity ^0.4.25;

contract W_WALLET {
    uint public minSum = 1 ether;
    
    struct Holder {
        uint unlockTime;
        uint balance;
    }
    
    mapping (address => Holder) public accounts;
    
    Log logFile;
    
    constructor(address log) public {
        logFile = Log(log);
    }
    
    function put(uint _unlockTime) public payable {
        Holder storage account = accounts[msg.sender];
        account.balance += msg.value;
        account.unlockTime = _unlockTime > now ? _unlockTime : now;
        logFile.addMessage(msg.sender, msg.value, "Put");
    }
    
    function collect(uint _am) public {
        Holder storage account = accounts[msg.sender];
        require(account.balance >= minSum && account.balance >= _am && now > account.unlockTime);
        account.balance -= _am;
        msg.sender.transfer(_am);
        logFile.addMessage(msg.sender, _am, "Collect");
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
    
    Message[] public history;
    
    function addMessage(address _adr, uint _val, string _data) public {
        Message memory newMsg = Message({
            sender: _adr,
            time: now,
            val: _val,
            data: _data
        });
        history.push(newMsg);
    }
}