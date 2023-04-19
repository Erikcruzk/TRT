pragma solidity ^0.4.19;

contract MONEY_BOX {
    struct Holder {
        uint unlockTime;
        uint balance;
    }
    
    mapping (address => Holder) public Acc;
    
    uint public MinSum;
    
    Log LogFile;
    
    bool initialized;
    
    function SetMinSum(uint _val) public {
        require(!initialized);
        MinSum = _val;
    }
    
    function SetLogFile(address _log) public {
        require(!initialized);
        LogFile = Log(_log);
    }
    
    function initialize() public {
        initialized = true;
    }
    
    function put(uint _lockTime) public payable {
        var acc = Acc[msg.sender];
        acc.balance += msg.value;
        if(now + _lockTime > acc.unlockTime) {
            acc.unlockTime = now + _lockTime;
        }
        LogFile.addMessage(msg.sender, msg.value, "Put");
    }
    
    function collect(uint _am) public {
        var acc = Acc[msg.sender];
        require(acc.balance >= MinSum && acc.balance >= _am && now > acc.unlockTime);
        acc.balance -= _am;
        LogFile.addMessage(msg.sender, _am, "Collect");
        msg.sender.transfer(_am);
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
        Message memory lastMsg = Message(_adr, _data, _val, now);
        history.push(lastMsg);
    }
}