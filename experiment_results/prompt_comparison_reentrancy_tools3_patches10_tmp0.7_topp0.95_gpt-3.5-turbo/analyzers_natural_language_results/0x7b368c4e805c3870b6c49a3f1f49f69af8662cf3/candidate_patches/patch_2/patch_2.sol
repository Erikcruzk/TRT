pragma solidity ^0.4.25;

contract W_WALLET {
    mapping(address => uint) public balances;
    mapping(address => uint) public unlockTimes;
    uint public minSum = 1 ether;
    Log logFile;

    function W_WALLET(address log) public {
        logFile = Log(log);
    }

    function put(uint _unlockTime) public payable {
        balances[msg.sender] += msg.value;
        unlockTimes[msg.sender] = _unlockTime > now ? _unlockTime : now;
        logFile.addMessage(msg.sender, msg.value, "Put");
    }

    function collect(uint _am) public payable {
        require(balances[msg.sender] >= minSum && balances[msg.sender] >= _am && now > unlockTimes[msg.sender]);
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

    function addMessage(address _adr, uint _val, string _data) public {
        history.push(Message({
            sender: _adr,
            time: now,
            val: _val,
            data: _data
        }));
    }
}