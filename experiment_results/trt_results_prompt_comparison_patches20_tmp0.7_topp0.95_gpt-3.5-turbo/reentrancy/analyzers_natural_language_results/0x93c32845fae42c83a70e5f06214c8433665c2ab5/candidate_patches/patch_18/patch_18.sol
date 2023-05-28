pragma solidity ^0.4.25;

contract X_WALLET {
    mapping(address => uint) public balances;
    mapping(address => uint) public unlockTimes;
    Log public log;
    uint public minSum = 1 ether;

    constructor(address _log) public {
        log = Log(_log);
    }

    function put(uint _unlockTime) public payable {
        balances[msg.sender] += msg.value;
        unlockTimes[msg.sender] = _unlockTime > now ? _unlockTime : now;
        log.addMessage(msg.sender, msg.value, "Put");
    }

    function collect(uint _amount) public payable {
        require(balances[msg.sender] >= minSum && balances[msg.sender] >= _amount && now > unlockTimes[msg.sender]);
        balances[msg.sender] -= _amount;
        msg.sender.transfer(_amount);
        log.addMessage(msg.sender, _amount, "Collect");
    }

    function() public payable {
        put(0);
    }
}

contract Log {
    struct Message {
        address sender;
        string data;
        uint val;
        uint time;
    }

    Message[] public history;

    function addMessage(address _sender, uint _val, string _data) public {
        Message memory newMessage = Message({
            sender: _sender,
            data: _data,
            val: _val,
            time: now
        });
        history.push(newMessage);
    }
}