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
    
    function setMinSum(uint _val) public {
        require(!initialized);
        MinSum = _val;
    }
    
    function setLogFile(address _log) public {
        require(!initialized);
        LogFile = Log(_log);
    }
    
    function initialize() public {
        initialized = true;
    }
    
    function put(uint _lockTime) public payable {
        Holder storage acc = Acc[msg.sender];
        acc.balance += msg.value;
        if (now + _lockTime > acc.unlockTime) {
            acc.unlockTime = now + _lockTime;
        }
        LogFile.addMessage(msg.sender, msg.value, "Put");
    }
    
    function collect(uint _am) public {
        Holder storage acc = Acc[msg.sender];
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
  "osiris": {
    "successfull_analysis": true,
    "errors": [
      "DOCKER_TIMEOUT"
    ],
    "vulnerability_findings": []
  },
  "slither": {
    "successfull_analysis": true,
    "errors": [
      "EXIT_CODE_30"
    ],
    "vulnerability_findings": [
      {
        "name": "reentrancy",
        "vulnerability_from_line": 49,
        "vulnerability_to_line": 61,
        "vulnerability_code": "    function collect(uint _am) public {\n        Holder storage acc = Acc[msg.sender];\n        require(acc.balance >= MinSum && acc.balance >= _am && now > acc.unlockTime);\n        acc.balance -= _am;\n        LogFile.addMessage(msg.sender, _am, \"Collect\");\n        msg.sender.transfer(_am);\n    }\n",
        "message": "Reentrancy in MONEY_BOX.collect (0xbe4041d55db380c5ae9d4a9b9703f1ed4e7e3888.sol#49-61):\n\tExternal calls:\n\t- msg.sender.transfer(_am) (0xbe4041d55db380c5ae9d4a9b9703f1ed4e7e3888.sol#59)\n\tState variables written after the call(s):\n\t- Acc (0xbe4041d55db380c5ae9d4a9b9703f1ed4e7e3888.sol#50)\n"
      }
    ]
  }
}

// Repaired the code by changing function names to conform to Solidity naming conventions, adding require statements for input validation, using storage and memory keywords correctly, fixing log data storage and using transfer() instead of call() in the collect() function.