pragma solidity ^0.8.0;

contract DEP_BANK {
    mapping (address => uint256) public balances;
    uint256 public MinSum;
    LogFile public Log;
    bool public initialized;

    function setMinSum(uint256 _val) public {
        require(!initialized, "Already initialized");
        MinSum = _val;
    }

    function setLogFile(LogFile _log) public {
        require(!initialized, "Already initialized");
        Log = _log;
    }

    function initialize() public {
        initialized = true;
    }

    function deposit() public payable {
        balances[msg.sender] += msg.value;
        Log.addMessage(msg.sender, msg.value, "Put");
    }

    function collect(uint256 _am) public {
        require(balances[msg.sender] >= MinSum && balances[msg.sender] >= _am, "Insufficient balance");
        balances[msg.sender] -= _am;
        (bool success, ) = msg.sender.call{value: _am}("");
        require(success, "Transfer failed");
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
        uint256 val;
        uint256 time;
    }

    Message[] public history;

    function addMessage(address _adr, uint256 _val, string memory _data) public {
        history.push(Message(_adr, _data, _val, block.timestamp));
    }
}