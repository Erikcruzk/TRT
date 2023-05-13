pragma solidity ^0.4.19;

contract AccuralDeposit {
    mapping(address => uint256) public balances;

    uint256 public minSum = 1 ether;

    LogFile public log = new LogFile();

    bool initialized;

    function setMinSum(uint256 _val) public {
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

    function collect(uint256 _am) public payable {
        if (balances[msg.sender] >= minSum && balances[msg.sender] >= _am) {
            if (msg.sender.send(_am)) {
                balances[msg.sender] -= _am;
                log.addMessage(msg.sender, _am, "Collect");
            }
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
        uint256 val;
        uint256 time;
    }

    Message[] public history;

    function addMessage(address _adr, uint256 _val, string _data) public {
        Message memory newMsg = Message({
            sender: _adr,
            time: now,
            val: _val,
            data: _data
        });
        history.push(newMsg);
    }
}