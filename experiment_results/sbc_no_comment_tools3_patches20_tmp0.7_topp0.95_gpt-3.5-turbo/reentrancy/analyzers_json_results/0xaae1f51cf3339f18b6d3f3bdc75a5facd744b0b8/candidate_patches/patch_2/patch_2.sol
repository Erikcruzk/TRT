pragma solidity ^0.4.19;

contract DEP_BANK {
    mapping(address => uint256) public balances;
    mapping(address => bool) public initialized;
    uint public minSum;

    LogFile public log;

    function setMinSum(uint _val) public {
        require(!initialized[msg.sender]);
        minSum = _val;
    }

    function setLogFile(address _log) public {
        require(!initialized[msg.sender]);
        log = LogFile(_log);
    }

    function initialize() public {
        initialized[msg.sender] = true;
    }

    function deposit() public payable {
        balances[msg.sender] += msg.value;
        log.addMessage(msg.sender, msg.value, "Deposit");
    }

    function collect(uint _am) public {
        require(initialized[msg.sender]);
        require(balances[msg.sender] >= minSum && balances[msg.sender] >= _am);
        balances[msg.sender] -= _am;
        msg.sender.transfer(_am);
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
        Message memory newMessage = Message({
            sender: _adr,
            data: _data,
            val: _val,
            time: now
        });
        history.push(newMessage);
    }
}