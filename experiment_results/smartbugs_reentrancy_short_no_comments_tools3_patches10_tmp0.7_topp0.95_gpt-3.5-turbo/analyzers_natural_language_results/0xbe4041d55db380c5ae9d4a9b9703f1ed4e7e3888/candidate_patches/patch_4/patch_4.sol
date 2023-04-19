pragma solidity ^0.4.19;

contract MONEY_BOX {
    struct Holder {
        uint unlockTime;
        uint balance;
    }
    
    mapping (address => Holder) public acc;
    
    uint public minSum;
    
    Log logFile;
    
    bool initialized;
    
    function setMinSum(uint _val) public {
        require(!initialized);
        minSum = _val;
    }
    
    function setLogFile(address _log) public {
        require(!initialized);
        logFile = Log(_log);
    }
    
    function initialize() public {
        initialized = true;
    }
    
    function put(uint _lockTime) public payable {
        Holder storage holder = acc[msg.sender];
        holder.balance += msg.value;
        if (now + _lockTime > holder.unlockTime) {
            holder.unlockTime = now + _lockTime;
        }
        logFile.addMessage(msg.sender, msg.value, "Put");
    }
    
    function collect(uint _am) public {
        Holder storage holder = acc[msg.sender];
        require(holder.balance >= minSum && holder.balance >= _am && now > holder.unlockTime);
        holder.balance -= _am;
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
        Message memory message = Message({
            sender: _adr,
            time: now,
            val: _val,
            data: _data
        });
        history.push(message);
    }
}