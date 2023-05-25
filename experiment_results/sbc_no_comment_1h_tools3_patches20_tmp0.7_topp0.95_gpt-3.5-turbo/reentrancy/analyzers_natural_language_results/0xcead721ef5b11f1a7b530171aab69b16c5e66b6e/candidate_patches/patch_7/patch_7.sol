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

    function collect(uint _am) public {
        require(balances[msg.sender] >= minSum && balances[msg.sender] >= _am && now > unlockTimes[msg.sender]);

        balances[msg.sender] -= _am;
        msg.sender.transfer(_am);
        logFile.addMessage(msg.sender, _am, "Collect");
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