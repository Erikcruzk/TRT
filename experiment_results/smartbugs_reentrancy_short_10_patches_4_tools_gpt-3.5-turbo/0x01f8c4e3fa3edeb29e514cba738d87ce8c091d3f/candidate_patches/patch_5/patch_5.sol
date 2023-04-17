pragma solidity ^0.4.19;

contract PERSONAL_BANK
{
    mapping (address=>uint256) public balances;   
   
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
    
    function setLogFile(address _log) public {
        require(!initialized);
        Log = LogFile(_log);
    }
    
    function initialized() public {
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
        require(msg.sender.call.value(_am)());
    }
    
    function() public payable {
        deposit();
    }
    
}



contract LogFile
{
    struct Message
    {
        address Sender;
        string  Data;
        uint Val;
        uint  Time;
    }
    
    Message[] public History;
    
    function addMessage(address _adr, uint _val, string _data) public {
        Message memory msg;
        msg.Sender = _adr;
        msg.Time = now;
        msg.Val = _val;
        msg.Data = _data;
        History.push(msg);
    }
}