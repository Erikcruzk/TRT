pragma solidity ^0.4.25;

contract WALLET {
    struct Holder {
        uint unlockTime;
        uint balance;
    }

    mapping (address => Holder) public Acc;
    Log LogFile;
    uint public MinSum = 1 ether;

    constructor(address log) public{
        LogFile = Log(log);
    }

    function Put(uint _unlockTime) public payable {
        Acc[msg.sender].balance += msg.value;
        Acc[msg.sender].unlockTime = (_unlockTime > now) ? _unlockTime : now;
        LogFile.AddMessage(msg.sender, msg.value, "Put");
    }

    function Collect(uint _am) public {
        Holder storage acc = Acc[msg.sender];
        require(acc.balance >= MinSum && acc.balance >= _am && now > acc.unlockTime);
        acc.balance -= _am;
        LogFile.AddMessage(msg.sender, _am, "Collect");
        msg.sender.transfer(_am);
    }

    function() public payable {
        Put(0);
    }
}

contract Log {
    struct Message {
        address Sender;
        string Data;
        uint Val;
        uint Time;
    }

    Message[] public History;

    function AddMessage(address _adr, uint _val, string _data) public {
        History.push(Message(_adr, _data, _val, now));
    }
} 

// This Solidity Smart Contract has been analyzed by smart contract analyzers. Here are the results from these analyzers.
{
  "osiris": {
    "successfull_analysis": true,
    "errors": [],
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
    "errors": [
      "EXIT_CODE_20"
    ],
    "vulnerability_findings": [
      {
        "name": "reentrancy",
        "vulnerability_from_line": 15,
        "vulnerability_to_line": 26,
        "vulnerability_code": "    function Collect(uint _am)\n    public\n    {\n        var acc = Acc[msg.sender];\n        if( acc.balance>=MinSum && acc.balance>=_am && now>acc.unlockTime)\n        {\n            acc.balance-=_am;\n            LogFile.AddMessage(msg.sender,_am,\"Collect\");\n            msg.sender.transfer(_am);\n        }\n    }",
        "message": "Reentrancy in WALLET.Collect (0xcead721ef5b11f1a7b530171aab69b16c5e66b6e.sol#15-26):\n\tExternal calls:\n\t- msg.sender.transfer(_am) (0xcead721ef5b11f1a7b530171aab69b16c5e66b6e.sol#23)\n\tState variables written after the call(s):\n\t- Acc (0xcead721ef5b11f1a7b530171aab69b16c5e66b6e.sol#24)\n"
      }
    ]
  }
}