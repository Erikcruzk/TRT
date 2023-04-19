pragma solidity ^0.4.19;

contract PENNY_BY_PENNY {
    struct Holder {
        uint unlockTime;
        uint balance;
    }
    
    mapping (address => Holder) public acc;
    
    uint public minSum;
    
    LogFile log;
    
    bool initialized;
    
    function setMinSum(uint _val) public {
        require(!initialized);
        minSum = _val;
    }
    
    function setLogFile(address _log) public {
        require(!initialized);
        log = LogFile(_log);
    }
    
    function initialize() public {
        initialized = true;
    }
    
    function put(uint _lockTime) public payable {
        Holder storage account = acc[msg.sender];
        account.balance += msg.value;
        if(now + _lockTime > account.unlockTime) {
            account.unlockTime = now + _lockTime;
        }
        log.addMessage(msg.sender, msg.value, "Put");
    }
    
    function collect(uint _am) public {
        Holder storage account = acc[msg.sender];
        require(account.balance >= minSum && account.balance >= _am && now > account.unlockTime);
        if(msg.sender.call.value(_am)()) {
            account.balance -= _am;
            log.addMessage(msg.sender, _am, "Collect");
        }
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