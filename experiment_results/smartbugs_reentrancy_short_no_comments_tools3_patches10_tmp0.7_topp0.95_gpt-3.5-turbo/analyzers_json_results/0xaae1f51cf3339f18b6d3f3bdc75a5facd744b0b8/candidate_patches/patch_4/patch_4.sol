pragma solidity ^0.4.19;

contract DEP_BANK {
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
        msg.sender.transfer(_am);
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

// osiris:
//   successfull_analysis: true
//   errors:
//   - DOCKER_TIMEOUT
//   vulnerability_findings:
//   - name: integer_over-underflow
//     vulnerability_from_line: 37
//     vulnerability_to_line: null
//     vulnerability_code: "        balances[msg.sender]+= msg.value;"
//     message: null
//   - name: reentrancy
//     vulnerability_from_line: 47
//     vulnerability_to_line: null
//     vulnerability_code: "            if(msg.sender.call.value(_am)())"
//     message: null
//   - name: reentrancy
//     vulnerability_from_line: 50
//     vulnerability_to_line: null
//     vulnerability_code: '                Log.addMessage(msg.sender, _am, "Collect");'
//     message: null
//   - name: integer_over-underflow
//     vulnerability_from_line: 49
//     vulnerability_to_line: null
//     vulnerability_code: "                balances[msg.sender]-=_am;"
//     message: null
// oyente:
//   successfull_analysis: true
//   errors: []
//   vulnerability_findings:
//   - name: reentrancy
//     vulnerability_from_line: 47
//     vulnerability_to_line: null
//     vulnerability_code: "            if(msg.sender.call.value(_am)())"
//     message: null
// slither:
//   successfull_analysis: true
//   errors:
//   - EXIT_CODE_28
//   vulnerability_findings:
//   - name: reentrancy
//     vulnerability_from_line: 41
//     vulnerability_to_line: 53
//     vulnerability_code: |-
//       function collect(uint _am) public {
//           require(balances[msg.sender] >= MinSum && balances[msg.sender] >= _am);
//           balances[msg.sender] -= _am;
//           msg.sender.transfer(_am);
//           Log.addMessage(msg.sender, _am, "Collect");
//       }
//     message: "Reentrancy in DEP_BANK.collect (0xaae1f51cf3339f18b6d3f3bdc75a5facd744b0b8.sol#41-53):\n\tExternal calls:\n\t- msg.sender.transfer(_am) (0xaae1f51cf3339f18b6d3f3bdc75a5facd744b0b8.sol#49)\n\tState variables written after the call(s):\n\t- balances (0xaae1f51cf3339f18b6d3f3bdc75a5facd744b0b8.sol#47)\n"