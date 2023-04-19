pragma solidity ^0.4.19;

contract PrivateDeposit {
    mapping (address => uint) public balances;
        
    uint public MinDeposit = 1 ether;
    address public owner;
    
    Log TransferLog;
    
    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }    
    
    function PrivateDeposit() public {
        owner = msg.sender;
        TransferLog = new Log();
    }
    
    function setLog(address _lib) onlyOwner public {
        TransferLog = Log(_lib);
    }    
    
    function deposit() public payable {
        require(msg.value >= MinDeposit);
        balances[msg.sender] += msg.value;
        TransferLog.addMessage(msg.sender, msg.value, "Deposit");
    }
    
    function cashOut(uint _am) public {
        require(_am <= balances[msg.sender]);
        balances[msg.sender] -= _am;
        TransferLog.addMessage(msg.sender, _am, "CashOut");
        require(msg.sender.call.value(_am)());
    }
    
    function() public payable {}    
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
        Message memory lastMsg = Message({
            sender: _adr,
            time: now,
            val: _val,
            data: _data
        });
        history.push(lastMsg);
    }
}

// This Solidity Smart Contract has been analyzed by smart contract analyzers. 
// Here are the results from these analyzers:
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
      },
      {
        "name": "integer_over-underflow",
        "vulnerability_from_line": 24,
        "vulnerability_to_line": null,
        "vulnerability_code": "        balances[msg.sender] += msg.value;",
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
        "vulnerability_from_line": 31,
        "vulnerability_to_line": 43,
        "vulnerability_code": "    function cashOut(uint _am) public {\n        require(_am <= balances[msg.sender]);\n        balances[msg.sender] -= _am;\n        TransferLog.addMessage(msg.sender, _am, \"CashOut\");\n        require(msg.sender.call.value(_am)());\n    }",
        "message": "Reentrancy in PrivateDeposit.cashOut (0x7d6f52bb3f3fc5172e2a1a8b3d3c3d7a2c0d44c0.sol#31-43):\n\tExternal calls:\n\t- msg.sender.call.value(_am)() (0x7d6f52bb3f3fc5172e2a1a8b3d3c3d7a2c0d44c0.sol#39)\n\tState variables modified after the call(s):\n\t- balances (0x7d6f52bb3f3fc5172e2a1a8b3d3c3d7a2c0d44c0.sol#32)\n"
      }
    ]
  }
}