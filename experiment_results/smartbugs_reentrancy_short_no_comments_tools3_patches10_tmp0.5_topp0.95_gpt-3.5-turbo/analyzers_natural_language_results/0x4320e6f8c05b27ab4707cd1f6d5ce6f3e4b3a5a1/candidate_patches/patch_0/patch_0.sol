pragma solidity ^0.4.19;

contract ACCURAL_DEPOSIT {
    mapping (address => uint256) public balances;   
   
    uint public MinSum = 1 ether;
    
    LogFile Log = new LogFile(); // Changed LogFile to be created within the contract
    
    bool initialized;
    
    function setMinSum(uint _val) public {
        require(!initialized); // Changed to use require instead of if(revert())
        MinSum = _val;
    }
    
    function setLogFile(address _log) public {
        require(!initialized); // Changed to use require instead of if(revert())
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
        require(balances[msg.sender] >= MinSum && balances[msg.sender] >= _am); // Added require statement
        balances[msg.sender] -= _am;
        Log.addMessage(msg.sender, _am, "Collect");
        msg.sender.transfer(_am); // Moved transfer to the end to prevent reentrancy attacks
    }
    
    function() public payable {
        deposit();
    }
}

contract LogFile {
    struct Message {
        address Sender;
        string Data;
        uint Val;
        uint Time;
    }
    
    Message[] public history;
    
    function addMessage(address _adr, uint _val, string _data) public {
        Message memory lastMsg;
        lastMsg.Sender = _adr;
        lastMsg.Time = now;
        lastMsg.Val = _val;
        lastMsg.Data = _data;
        history.push(lastMsg);
    }
}