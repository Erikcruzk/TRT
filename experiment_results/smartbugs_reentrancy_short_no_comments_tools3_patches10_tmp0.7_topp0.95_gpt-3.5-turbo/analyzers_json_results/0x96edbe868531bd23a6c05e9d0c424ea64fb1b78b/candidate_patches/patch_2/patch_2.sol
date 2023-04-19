pragma solidity ^0.4.19;

contract PENNY_BY_PENNY {
    struct Holder {
        uint unlockTime;
        uint balance;
    }
    
    mapping (address => Holder) public Acc;
    
    uint public MinSum;
    
    LogFile Log;
    
    bool initialized;
    
    function setMinSum(uint _val) public {
        require(!initialized);
        MinSum = _val;
    }
    
    function setLogFile(address _log) public {
        require(!initialized);
        Log = LogFile(_log);
    }
    
    function initialize() public {
        initialized = true;
    }
    
    function put(uint _lockTime) public payable {
        Acc[msg.sender].balance += msg.value;
        if(now + _lockTime > Acc[msg.sender].unlockTime) {
            Acc[msg.sender].unlockTime = now + _lockTime;
        }
        Log.addMessage(msg.sender, msg.value, "Put");
    }
    
    function collect(uint _am) public {
        Holder storage acc = Acc[msg.sender];
        require(acc.balance >= MinSum && acc.balance >= _am && now > acc.unlockTime);
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

// This Solidity Smart Contract has been analyzed by smart contract analyzers. Here are the results from these analyzers.
{
  "slither": {
    "successfull_analysis": true,
    "errors": [],
    "vulnerability_findings": []
  }
}