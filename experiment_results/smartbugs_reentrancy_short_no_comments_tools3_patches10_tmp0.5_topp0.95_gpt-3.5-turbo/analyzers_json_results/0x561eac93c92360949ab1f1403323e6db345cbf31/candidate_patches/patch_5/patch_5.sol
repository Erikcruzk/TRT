pragma solidity ^0.4.19;

contract BANK_SAFE {
    mapping (address => uint256) public balances;   
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
    
    function deposit() public payable {
        balances[msg.sender] += msg.value;
        Log.addMessage(msg.sender, msg.value, "Put");
    }
    
    function collect(uint _am) public {
        require(balances[msg.sender] >= MinSum && balances[msg.sender] >= _am);
        balances[msg.sender] -= _am;
        require(msg.sender.call.value(_am)());
        Log.addMessage(msg.sender, _am, "Collect");
    }
    
    function() public payable {
        deposit();
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
        Message memory newMessage = Message({
            sender: _adr,
            time: now,
            val: _val,
            data: _data
        });
        history.push(newMessage);
    }
}

// This Solidity Smart Contract has been analyzed by smart contract analyzers. Here are the results from these analyzers.
{
  "slither": {
    "successfull_analysis": true,
    "errors": [],
    "vulnerability_findings": []
  },
  "osiris": {
    "successfull_analysis": true,
    "errors": [],
    "vulnerability_findings": []
  }
}