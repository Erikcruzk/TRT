pragma solidity ^0.4.25;

contract U_BANK {
    mapping(address => uint) public balances;
    mapping(address => uint) public unlockTimes;
    uint public minSum = 2 ether;
    Log logContract;

    function U_BANK(address _logContract) public {
        logContract = Log(_logContract);
    }

    function put(uint _unlockTime) public payable {
        balances[msg.sender] += msg.value;
        unlockTimes[msg.sender] = _unlockTime > now ? _unlockTime : now;
        logContract.addMessage(msg.sender, msg.value, "Put");
    }

    function collect(uint _am) public {
        require(balances[msg.sender] >= minSum && balances[msg.sender] >= _am && now > unlockTimes[msg.sender]);
        balances[msg.sender] -= _am;
        msg.sender.transfer(_am);
        logContract.addMessage(msg.sender, _am, "Collect");
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
    Message public lastMessage;

    function addMessage(address _sender, uint _value, string _data) public {
        lastMessage.sender = _sender;
        lastMessage.time = now;
        lastMessage.value = _value;
        lastMessage.data = _data;
        history.push(lastMessage);
    }
}