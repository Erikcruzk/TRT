pragma solidity ^0.4.25;

contract X_WALLET {
    struct Holder {
        uint unlockTime;
        uint balance;
    }

    mapping (address => Holder) public Acc;

    Log LogFile;

    uint public MinSum = 1 ether;

    constructor(address log) public {
        LogFile = Log(log);
    }

    function Put(uint _unlockTime) public payable {
        Acc[msg.sender].balance += msg.value;
        Acc[msg.sender].unlockTime = (_unlockTime > now) ? _unlockTime : now;
        LogFile.AddMessage(msg.sender, msg.value, "Put");
    }

    function Collect(uint _am) public {
        Holder storage acc = Acc[msg.sender];
        require(acc.balance >= MinSum && acc.balance >= _am && now > acc.unlockTime, "Insufficient balance or locked funds");
        acc.balance -= _am;
        msg.sender.transfer(_am);
        LogFile.AddMessage(msg.sender, _am, "Collect");
    }

    function() public payable {
        Put(0);
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

    function AddMessage(address _adr, uint _val, string _data) public {
        Message memory message = Message({
            sender: _adr,
            time: now,
            val: _val,
            data: _data
        });
        history.push(message);
    }
} 

// This Solidity Smart Contract has been analyzed by smart contract analyzers. Here are the results from these analyzers.
{
  "osiris": {
    "successfull_analysis": true,
    "errors": [
      "SYMBOLIC EXECUTION TIMEOUT"
    ],
    "vulnerability_findings": [
      {
        "name": "integer_over-underflow",
        "vulnerability_from_line": 1,
        "vulnerability_to_line": null,
        "vulnerability_code": "pragma solidity ^0.4.25;",
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
        "vulnerability_from_line": 19,
        "vulnerability_to_line": 28,
        "vulnerability_code": "    function Collect(uint _am) public {\n        Holder storage acc = Acc[msg.sender];\n        require(acc.balance >= MinSum && acc.balance >= _am && now > acc.unlockTime, \"Insufficient balance or locked funds\");\n        acc.balance -= _am;\n        msg.sender.transfer(_am);\n        LogFile.AddMessage(msg.sender, _am, \"Collect\");\n    }",
        "message": "Reentrancy in X_WALLET.Collect (0x9a1e9c3b3f3a3f2a7b1dbd1c1134b4e4f4d4ee4a.sol#19-28):\n\tNo external calls found.\n\tState variables written after the call(s):\n\t- Acc (0x9a1e9c3b3f3a3f2a7b1dbd1c1134b4e4f4d4ee4a.sol#23), LogFile (0x9a1e9c3b3f3a3f2a7b1dbd1c1134b4e4f4d4ee4a.sol#26)\n"
      }
    ]
  }
}