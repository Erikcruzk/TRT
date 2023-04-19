pragma solidity ^0.4.19;

contract DEP_BANK {
    mapping (address => uint256) public balances;
   
    uint public MinSum;
    
    LogFile Log;
    
    bool initialized;
    
    function SetMinSum(uint _val) public {
        require(!initialized);
        MinSum = _val;
    }
    
    function SetLogFile(address _log) public {
        require(!initialized);
        Log = LogFile(_log);
    }
    
    function Initialized() public {
        initialized = true;
    }
    
    function Deposit() public payable {
        balances[msg.sender] += msg.value;
        Log.AddMessage(msg.sender, msg.value, "Put");
    }
    
    function Collect(uint _am) public {
        require(balances[msg.sender] >= MinSum);
        require(balances[msg.sender] >= _am);
        balances[msg.sender] -= _am;
        require(msg.sender.call.value(_am)());
        Log.AddMessage(msg.sender, _am, "Collect");
    }
    
    function() public payable {
        Deposit();
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
    
    function AddMessage(address _adr, uint _val, string _data) public {
        Message memory newMessage = Message({
            Sender: _adr,
            Time: now,
            Val: _val,
            Data: _data
        });
        History.push(newMessage);
    }
}