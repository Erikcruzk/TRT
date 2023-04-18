pragma solidity ^0.4.19;

contract PERSONAL_BANK {
    mapping (address => uint256) public balances;
    uint public MinSum = 1 ether;
    LogFile public Log;
    bool public initialized;

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
        Log.addMessage(msg.sender, _am, "Collect");
        require(msg.sender.send(_am));
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

// This Solidity Smart Contract has been analyzed by smart contract analyzers. Here are the results from these analyzers.
{
  "slither": {
    "successfull_analysis": true,
    "errors": [],
    "vulnerability_findings": []
  },
  "osiris": {
    "successfull_analysis": true,
    "errors": [
      "DOCKER_TIMEOUT"
    ],
    "vulnerability_findings": [
      {
        "name": "integer_over-underflow",
        "vulnerability_from_line": 1,
        "vulnerability_to_line": null,
        "vulnerability_code": "pragma solidity ^0.4.19;",
        "message": null
      },
      {
        "name": "integer_over-underflow",
        "vulnerability_from_line": 87,
        "vulnerability_to_line": null,
        "vulnerability_code": "        history.push(newMsg);",
        "message": null
      },
      {
        "name": "integer_over-underflow",
        "vulnerability_from_line": 87,
        "vulnerability_to_line": null,
        "vulnerability_code": "        history.push(newMsg);",
        "message": null
      }
    ]
  }
}