pragma solidity ^0.8.0;

contract DEP_BANK {
    mapping (address => uint256) public balances;
    uint public minSum;
    LogFile public log;
    bool private initialized;

    function setMinSum(uint _val) public {
        require(!initialized, "Already initialized");
        minSum = _val;
    }
    
    function setLogFile(LogFile _log) public {
        require(!initialized, "Already initialized");
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
        require(balances[msg.sender] >= minSum && balances[msg.sender] >= _am, "Insufficient balance");
        balances[msg.sender] -= _am;
        (bool success, ) = msg.sender.call{value: _am}("");
        require(success, "Transfer failed.");
        log.addMessage(msg.sender, _am, "Collect");
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
        Message memory lastMsg = Message({
            sender: _adr,
            time: block.timestamp,
            val: _val,
            data: _data
        });
        history.push(lastMsg);
    }
}