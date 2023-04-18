pragma solidity ^0.4.19;

contract AccrualDeposit {
    mapping (address => uint256) public balances;   
   
    uint public minSum = 1 ether;
    
    LogFile public log;
    
    bool initialized;
    
    function setMinSum(uint _val) public {
        require(!initialized);
        minSum = _val;
    }
    
    function setLogFile(LogFile _log) public {
        require(!initialized);
        log = _log;
    }
    
    function initialize() public {
        initialized = true;
    }
    
    function deposit() public payable {
        balances[msg.sender] += msg.value;
        log.addMessage(msg.sender, msg.value, "Put");
    }
    
    function collect(uint _am) public {
        require(balances[msg.sender] >= minSum && balances[msg.sender] >= _am);
        if(msg.sender.send(_am)) {
            balances[msg.sender] -= _am;
            log.addMessage(msg.sender, _am, "Collect");
        }
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
        Message memory newMessage;
        newMessage.sender = _adr;
        newMessage.time = now;
        newMessage.val = _val;
        newMessage.data = _data;
        history.push(newMessage);
    }
}