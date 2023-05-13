pragma solidity ^0.4.19;

contract DEP_BANK {
    mapping(address => uint256) public balances;
    mapping(address => bool) public initialized;

    uint public minSum;

    LogFile log;

    function setMinSum(uint _val) public {
        require(!initialized[msg.sender]);
        minSum = _val;
        initialized[msg.sender] = true;
    }

    function setLogFile(address _log) public {
        require(!initialized[msg.sender]);
        log = LogFile(_log);
        initialized[msg.sender] = true;
    }

    function deposit() public payable {
        balances[msg.sender] += msg.value;
        log.addMessage(msg.sender, msg.value, "Put");
    }

    function collect(uint _am) public {
        require(balances[msg.sender] >= minSum && balances[msg.sender] >= _am);
        balances[msg.sender] -= _am;
        require(msg.sender.call.value(_am)());
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
        history.push(Message({
            sender: _adr,
            data: _data,
            val: _val,
            time: now
        }));
    }
}