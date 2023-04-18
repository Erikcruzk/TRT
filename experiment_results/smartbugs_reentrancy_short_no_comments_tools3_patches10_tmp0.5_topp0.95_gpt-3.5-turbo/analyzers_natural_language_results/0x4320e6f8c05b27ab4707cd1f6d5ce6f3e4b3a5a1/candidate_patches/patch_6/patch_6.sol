pragma solidity ^0.4.19;

contract ACCURAL_DEPOSIT {
    mapping (address => uint256) public balances;   
   
    uint public MinSum = 1 ether;
    
    LogFile Log;
    
    bool initialized;
    
    function ACCURAL_DEPOSIT(address _log) public {
        Log = LogFile(_log);
    }
    
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
        Message memory newMsg = Message({
            sender: _adr,
            time: now,
            val: _val,
            data: _data
        });
        history.push(newMsg);
    }
} 

// Changes Made:
// 1. Added constructor to initialize LogFile contract address
// 2. Changed function names to follow Solidity naming conventions
// 3. Added require statements to check for conditions before executing code
// 4. Moved balance deduction before external call in collect function to prevent reentrancy vulnerability
// 5. Changed struct variable name to avoid conflict with function name