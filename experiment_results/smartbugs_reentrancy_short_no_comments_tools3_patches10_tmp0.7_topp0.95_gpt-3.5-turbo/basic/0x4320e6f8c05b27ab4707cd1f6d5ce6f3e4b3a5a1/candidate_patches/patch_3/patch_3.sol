pragma solidity ^0.4.19;

contract ACCRUAL_DEPOSIT {
    mapping (address => uint256) public balances;
    uint public minSum = 1 ether;
    LogFile public log;
    bool public initialized;

    function setMinSum(uint _val) public {
        require(!initialized);
        minSum = _val;
    }

    function setLogFile(address _log) public {
        require(!initialized);
        log = LogFile(_log);
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
        balances[msg.sender] -= _am;
        require(msg.sender.send(_am));
        log.addMessage(msg.sender, _am, "Collect");
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
        Message memory newMessage = Message(_adr, _data, _val, now);
        history.push(newMessage);
    }
}