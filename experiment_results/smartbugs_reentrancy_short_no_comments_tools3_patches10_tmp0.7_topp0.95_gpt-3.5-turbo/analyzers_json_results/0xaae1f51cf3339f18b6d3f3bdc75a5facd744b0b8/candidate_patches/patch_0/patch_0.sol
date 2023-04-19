pragma solidity ^0.4.19;

contract DEP_BANK {
    mapping (address => uint256) public balances;
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

    function deposit() public payable {
        balances[msg.sender] += msg.value;
        log.addMessage(msg.sender, msg.value, "Deposit");
    }

    function collect(uint _am) public {
        require(balances[msg.sender] >= minSum);
        require(balances[msg.sender] >= _am);
        balances[msg.sender] -= _am;
        msg.sender.transfer(_am);
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
  "oyente": {
    "successfull_analysis": true,
    "errors": [],
    "vulnerability_findings": []
  },
  "slither": {
    "successfull_analysis": true,
    "errors": [
      "EXIT_CODE_28"
    ],
    "vulnerability_findings": []
  }
}