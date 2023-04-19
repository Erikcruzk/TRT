pragma solidity ^0.8.0;

contract BANK_SAFE {
    mapping (address => uint256) public balances;   
    uint public MinSum;
    LogFile Log;
    bool initialized;
    
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
        Log.addMessage(msg.sender, msg.value, "Deposit");
    }
    
    function collect(uint _am) public payable {
        require(balances[msg.sender] >= MinSum, "Balance is less than minimum sum");
        require(balances[msg.sender] >= _am, "Insufficient balance");
        balances[msg.sender] -= _am;
        (bool success,) = msg.sender.call{value: _am}("");
        require(success, "Transfer failed.");
        Log.addMessage(msg.sender, _am, "Collect");
    }
    
    receive() external payable {
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
        lastMsg.time = block.timestamp;
        lastMsg.val = _val;
        lastMsg.data = _data;
        history.push(lastMsg);
    }
}