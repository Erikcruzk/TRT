pragma solidity ^0.4.19;

contract PERSONAL_BANK {
    mapping (address => uint256) public balances;
    uint public minSum = 1 ether;
    LogFile public log;
    bool public initialized;

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

    function deposit() public payable {
        balances[msg.sender] += msg.value;
        log.addMessage(msg.sender, msg.value, "Put");
    }

    function collect(uint _am) public {
        require(balances[msg.sender] >= minSum && balances[msg.sender] >= _am);
        balances[msg.sender] -= _am;
        require(msg.sender.call.value(_am)());
        log.addMessage(msg.sender, _am, "Collect");
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
        Message memory newMsg;
        newMsg.sender = _adr;
        newMsg.time = now;
        newMsg.val = _val;
        newMsg.data = _data;
        history.push(newMsg);
    }
} 

/*
This Solidity Smart Contract has been analyzed by smart contract analyzers. Here are the results from these analyzers.
{
  "osiris": {
    "successfull_analysis": true,
    "errors": [],
    "vulnerability_findings": [
      {
        "name": "integer_over-underflow",
        "vulnerability_from_line": 1,
        "vulnerability_to_line": null,
        "vulnerability_code": "pragma solidity ^0.4.19;",
        "message": null
      }
    ]
  },
  "slither": {
    "successfull_analysis": true,
    "errors": [],
    "vulnerability_findings": [
      {
        "name": "reentrancy",
        "vulnerability_from_line": 32,
        "vulnerability_to_line": 44,
        "vulnerability_code": "    function collect(uint _am) public {\n        require(balances[msg.sender] >= minSum && balances[msg.sender] >= _am);\n        balances[msg.sender] -= _am;\n        require(msg.sender.call.value(_am)());\n        log.addMessage(msg.sender, _am, \"Collect\");\n    }",
        "message": "Reentrancy in PERSONAL_BANK.collect (0x6d53c8d2f5e5f78e5e5d7b8c4b9ad9d4c4f4d4e8.sol#32-44):\n\tExternal calls:\n\t- msg.sender.call.value(_am)() (0x6d53c8d2f5e5f78e5e5d7b8c4b9ad9d4c4f4d4e8.sol#38-38)\n\tState variables written after the call(s):\n\t- balances (0x6d53c8d2f5e5f78e5e5d7b8c4b9ad9d4c4f4d4e8.sol#36)\n"
      }
    ]
  }
}
*/