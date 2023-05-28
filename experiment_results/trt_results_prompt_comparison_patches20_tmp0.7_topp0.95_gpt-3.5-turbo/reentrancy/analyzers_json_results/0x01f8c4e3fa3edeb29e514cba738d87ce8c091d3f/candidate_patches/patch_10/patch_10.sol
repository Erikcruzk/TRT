pragma solidity ^0.4.19;

contract PERSONAL_BANK {
    mapping(address => uint256) public balances;

    uint public MinSum = 1 ether;

    LogFile Log;

    bool initialized;

    function PERSONAL_BANK(address _log) public {
        Log = LogFile(_log);
    }

    function setMinSum(uint _val) public {
        require(!initialized);
        MinSum = _val;
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
        history.push(Message(_adr, _data, _val, now));
    }
}

// This Solidity Smart Contract has been analyzed by smart contract analyzers. Here are the results from these analyzers.
{
  "securify": {
    "successfull_analysis": true,
    "errors": [],
    "vulnerability_findings": []
  },
  "slither": {
    "successfull_analysis": true,
    "errors": [
      "EXIT_CODE_26"
    ],
    "vulnerability_findings": []
  },
  "oyente": {
    "successfull_analysis": true,
    "errors": [],
    "vulnerability_findings": []
  }
}

// Changes Made:
// 1. Added constructor to initialize the LogFile contract.
// 2. Replaced intitalized variable with initialized variable and used require instead of if(intitalized) revert().
// 3. Modified Collect function to follow the checks-effects-interactions pattern.
// 4. Modified the struct and variable names to follow Solidity naming conventions.