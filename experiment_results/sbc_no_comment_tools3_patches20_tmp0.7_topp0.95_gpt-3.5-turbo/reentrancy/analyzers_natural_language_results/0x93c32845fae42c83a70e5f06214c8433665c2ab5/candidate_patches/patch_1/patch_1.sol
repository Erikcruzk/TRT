pragma solidity ^0.4.25;

contract X_WALLET {
    mapping(address => uint) public balances;
    mapping(address => uint) public unlockTimes;
    Log public logFile;
    uint public minSum = 1 ether;

    function X_WALLET(address _log) public {
        logFile = Log(_log);
    }

    function put(uint _unlockTime) public payable {
        balances[msg.sender] += msg.value;
        unlockTimes[msg.sender] = _unlockTime > now ? _unlockTime : now;
        logFile.addMessage(msg.sender, msg.value, "Put");
    }

    function collect(uint _am) public {
        require(balances[msg.sender] >= minSum);
        require(balances[msg.sender] >= _am);
        require(now > unlockTimes[msg.sender]);

        balances[msg.sender] -= _am;
        if (msg.sender.call.value(_am)()) {
            logFile.addMessage(msg.sender, _am, "Collect");
        }
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
        history.push(Message(_sender, _data, _val, now));
    }
}