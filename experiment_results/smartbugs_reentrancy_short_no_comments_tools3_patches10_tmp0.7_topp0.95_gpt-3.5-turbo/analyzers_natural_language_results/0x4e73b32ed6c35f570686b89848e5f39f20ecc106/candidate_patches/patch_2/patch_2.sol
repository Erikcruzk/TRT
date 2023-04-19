pragma solidity ^0.8.0;

contract PRIVATE_ETH_CELL {
    mapping (address => uint256) public balances;   
    uint public MinSum;
    LogFile public Log;
    bool public initialized;
    
    function setMinSum(uint _val) public {
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
    
    function deposit() public payable {
        balances[msg.sender] += msg.value;
        Log.addMessage(msg.sender, msg.value, "Put");
    }
    
    function collect(uint _am) public {
        require(balances[msg.sender] >= MinSum && balances[msg.sender] >= _am, "Insufficient funds");
        balances[msg.sender] -= _am;
        (bool success, ) = msg.sender.call{value: _am}("");
        require(success, "Failed to send ether");
        Log.addMessage(msg.sender, _am, "Collect");
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
        history.push(Message({
            sender: _adr,
            time: block.timestamp,
            val: _val,
            data: _data
        }));
    }
}