pragma solidity ^0.5.0;

contract PERSONAL_BANK {
    mapping (address => uint256) public balances;
   
    uint public MinSum = 1 ether;
    
    LogFile Log;
    
    bool initialized;
    
    constructor(address _log) public {
        Log = LogFile(_log);
    }
    
    function setMinSum(uint _val) public {
        require(!initialized, "Contract already initialized");
        MinSum = _val;
    }
    
    function setLogFile(address _log) public {
        require(!initialized, "Contract already initialized");
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
        require(balances[msg.sender] >= MinSum, "Balance is below minimum sum");
        require(balances[msg.sender] >= _am, "Insufficient balance");
        balances[msg.sender] -= _am;
        Log.addMessage(msg.sender, _am, "Collect");
        (bool success, ) = msg.sender.call.value(_am)("");
        require(success, "Transfer failed");
    }
    
    function() external payable {
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
    
    function addMessage(address _adr, uint _val, string memory _data) public {
        Message memory lastMsg;
        lastMsg.sender = _adr;
        lastMsg.time = now;
        lastMsg.val = _val;
        lastMsg.data = _data;
        history.push(lastMsg);
    }
}