pragma solidity ^0.8.0;

contract PersonalBank {
    mapping(address => uint256) public balances;

    uint256 public minSum = 1 ether;

    LogFile public log;

    bool public initialized;

    function setMinSum(uint256 _val) public {
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

    function collect(uint256 _am) public payable {
        require(balances[msg.sender] >= minSum && balances[msg.sender] >= _am, "Insufficient balance");
        require(msg.sender.call{value: _am}(), "Transfer failed");
        balances[msg.sender] -= _am;
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
        uint256 val;
        uint256 time;
    }

    Message[] public history;

    function addMessage(address _adr, uint256 _val, string memory _data) public {
        Message memory newMsg = Message({
            sender: _adr,
            time: block.timestamp,
            val: _val,
            data: _data
        });
        history.push(newMsg);
    }
}