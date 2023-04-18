pragma solidity ^0.8.0;

contract DEP_BANK {
    mapping (address => uint256) public balances;   
    uint256 public minSum;
    LogFile log;
    bool initialized;
    
    constructor() {
        minSum = 0;
        initialized = false;
    }
    
    function setMinSum(uint256 _val) public {
        require(!initialized, "Already initialized");
        minSum = _val;
    }
    
    function setLogFile(address _log) public {
        require(!initialized, "Already initialized");
        log = LogFile(_log);
    }
    
    function initialize() public {
        initialized = true;
    }
    
    function deposit() public payable {
        balances[msg.sender] += msg.value;
        log.addMessage(msg.sender, msg.value, "Put");
    }
    
    function collect(uint256 _am) public {
        require(balances[msg.sender] >= minSum, "Insufficient balance");
        require(balances[msg.sender] >= _am, "Insufficient balance");
        balances[msg.sender] -= _am;
        (bool success, ) = msg.sender.call{value: _am}("");
        require(success, "Transfer failed.");
        log.addMessage(msg.sender, _am, "Collect");
    }
    
    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }
    
    receive() external payable {
        deposit();
    }
}


contract LogFile {
    struct Message {
        address sender;
        string data;
        uint256 val;
        uint256 time;
    }
    
    Message[] public history;
    
    function addMessage(address _adr, uint256 _val, string memory _data) public {
        Message memory lastMsg = Message({
            sender: _adr,
            time: block.timestamp,
            val: _val,
            data: _data
        });
        history.push(lastMsg);
    }
}