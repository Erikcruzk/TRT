pragma solidity ^0.4.25;

contract WALLET {
    mapping(address => uint) public balances;
    mapping(address => uint) public unlockTimes;
    Log public logFile;
    uint public minSum = 1 ether;

    function WALLET(address _log) public {
        logFile = Log(_log);
    }

    function put(uint _unlockTime) public payable {
        balances[msg.sender] += msg.value;
        unlockTimes[msg.sender] = _unlockTime > now ? _unlockTime : now;
        logFile.addMessage(msg.sender, msg.value, "Put");
    }

    function collect(uint _amount) public {
        require(balances[msg.sender] >= minSum && balances[msg.sender] >= _amount && now > unlockTimes[msg.sender], "Insufficient balance or locked funds.");
        balances[msg.sender] -= _amount;
        msg.sender.transfer(_amount);
        logFile.addMessage(msg.sender, _amount, "Collect");
    }

    function() public payable {
        put(0);
    }
}

contract Log {
    struct Message {
        address sender;
        string data;
        uint value;
        uint time;
    }

    Message[] public history;

    function addMessage(address _sender, uint _value, string _data) public {
        Message memory newMessage = Message({
            sender: _sender,
            data: _data,
            value: _value,
            time: now
        });
        history.push(newMessage);
    }
}