pragma solidity ^0.8.0;

contract PENNY_BY_PENNY {
    struct Holder {
        uint256 unlockTime;
        uint256 balance;
    }
    
    mapping(address => Holder) public Acc;
    
    uint256 public MinSum;
    
    LogFile Log;
    
    bool initialized;
    
    constructor() {
        initialized = false;
    }
    
    function setMinSum(uint256 _val) public {
        require(!initialized, "Already initialized");
        MinSum = _val;
    }
    
    function setLogFile(address _log) public {
        require(!initialized, "Already initialized");
        Log = LogFile(_log);
    }
    
    function initialize() public {
        initialized = true;
    }
    
    function put(uint256 _lockTime) public payable {
        Holder storage acc = Acc[msg.sender];
        acc.balance += msg.value;
        if (now + _lockTime > acc.unlockTime) {
            acc.unlockTime = now + _lockTime;
        }
        Log.addMessage(msg.sender, msg.value, "Put");
    }
    
    function collect(uint256 _am) public payable {
        Holder storage acc = Acc[msg.sender];
        require(acc.balance >= MinSum, "Balance is less than minimum sum");
        require(acc.balance >= _am, "Not enough balance to collect");
        require(now > acc.unlockTime, "Funds are locked");
        acc.balance -= _am;
        (bool success, ) = msg.sender.call{value: _am}("");
        require(success, "Transfer failed");
        Log.addMessage(msg.sender, _am, "Collect");
    }
    
    receive() external payable {
        put(0);
    }
}

contract LogFile {
    struct Message {
        address Sender;
        string Data;
        uint256 Val;
        uint256 Time;
    }
    
    Message[] public History;
    
    function addMessage(address _adr, uint256 _val, string memory _data) public {
        Message memory lastMsg = Message(_adr, _data, _val, block.timestamp);
        History.push(lastMsg);
    }
}