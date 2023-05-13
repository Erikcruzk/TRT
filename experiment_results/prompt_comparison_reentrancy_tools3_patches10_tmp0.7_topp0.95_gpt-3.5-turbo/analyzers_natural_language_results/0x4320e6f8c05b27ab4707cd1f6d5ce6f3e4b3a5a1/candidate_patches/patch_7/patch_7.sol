pragma solidity ^0.4.19;

contract ACCURAL_DEPOSIT {
    mapping(address => uint256) public balances;
    mapping(address => bool) public initialized;

    uint public minSum = 1 ether;

    LogFile public log;

    function setMinSum(uint _val) public {
        require(!initialized[msg.sender]);
        minSum = _val;
    }

    function setLogFile(LogFile _log) public {
        require(!initialized[msg.sender]);
        log = _log;
    }

    function initialize() public {
        initialized[msg.sender] = true;
    }

    function deposit() public payable {
        balances[msg.sender] += msg.value;
        log.addMessage(msg.sender, msg.value, "Put");
    }

    function collect(uint _am) public {
        require(initialized[msg.sender]);
        require(balances[msg.sender] >= minSum && balances[msg.sender] >= _am);
        balances[msg.sender] -= _am;
        log.addMessage(msg.sender, _am, "Collect");
        require(msg.sender.call.value(_am)());
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
            time: now,
            val: _val,
            data: _data
        });
        history.push(newMessage);
    }
}