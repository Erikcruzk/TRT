pragma solidity ^0.4.19;

contract DEP_BANK {
    mapping (address => uint256) public balances;   
   
    uint public MinSum;
    
    LogFile Log;
    
    bool intitalized;
    
    function DEP_BANK() public {
        intitalized = false;
    }
    
    function SetMinSum(uint _val) public {
        require(!intitalized);
        MinSum = _val;
    }
    
    function SetLogFile(address _log) public {
        require(!intitalized);
        Log = LogFile(_log);
    }
    
    function Initialized() public {
        intitalized = true;
    }
    
    function Deposit() public payable {
        balances[msg.sender] += msg.value;
        Log.AddMessage(msg.sender, msg.value, "Put");
    }
    
    function Collect(uint _am) public {
        require(balances[msg.sender] >= MinSum && balances[msg.sender] >= _am);
        balances[msg.sender] -= _am;
        msg.sender.transfer(_am);
        Log.AddMessage(msg.sender, _am, "Collect");
    }
    
    function() public payable {
        Deposit();
    }
    
}


contract LogFile {
    struct Message {
        address Sender;
        string  Data;
        uint Val;
        uint  Time;
    }
    
    Message[] public History;
    
    function AddMessage(address _adr, uint _val, string _data) public {
        Message memory msg;
        msg.Sender = _adr;
        msg.Time = now;
        msg.Val = _val;
        msg.Data = _data;
        History.push(msg);
    }
}