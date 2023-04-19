pragma solidity ^0.4.19;

contract PENNY_BY_PENNY {
    struct Holder {
        uint unlockTime;
        uint balance;
        bool initialized;
    }
    
    mapping (address => Holder) public Acc;
    
    uint public MinSum;
    
    LogFile Log;
    
    function setMinSum(uint _val) public {
        require(!Acc[msg.sender].initialized);
        MinSum = _val;
    }
    
    function setLogFile(address _log) public {
        require(!Acc[msg.sender].initialized);
        Log = LogFile(_log);
    }
    
    function put(uint _lockTime) public payable {
        var acc = Acc[msg.sender];
        acc.balance += msg.value;
        if(now + _lockTime > acc.unlockTime) {
            acc.unlockTime = now + _lockTime;
        }
        Log.addMessage(msg.sender, msg.value, "Put");
    }
    
    function collect(uint _am) public {
        var acc = Acc[msg.sender];
        require(acc.balance >= MinSum && acc.balance >= _am && now > acc.unlockTime);
        acc.initialized = true;
        acc.balance -= _am;
        msg.sender.transfer(_am);
        Log.addMessage(msg.sender, _am, "Collect");
    }
    
    function() public payable {
        put(0);
    }
    
}

contract LogFile {
    struct Message {
        address sender;
        string data;
        uint val;
        uint time;
    }
    
    Message[] public History;
    
    function addMessage(address _adr, uint _val, string _data) public {
        Message memory newMessage = Message({
            sender: _adr,
            time: now,
            val: _val,
            data: _data
        });
        History.push(newMessage);
    }
}