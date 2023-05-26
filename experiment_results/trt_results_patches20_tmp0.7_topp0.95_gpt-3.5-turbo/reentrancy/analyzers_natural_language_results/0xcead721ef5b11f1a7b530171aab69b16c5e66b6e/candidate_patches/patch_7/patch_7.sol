pragma solidity ^0.4.25;

contract WALLET {
    mapping(address => uint) public balances;
    mapping(address => uint) public unlockTimes;
    uint public minSum = 1 ether;
    Log public log;

    function WALLET(address logAddress) public {
        log = Log(logAddress);
    }

    function put(uint unlockTime) public payable {
        balances[msg.sender] += msg.value;
        unlockTimes[msg.sender] = unlockTime > now ? unlockTime : now;
        log.addMessage(msg.sender, msg.value, "Put");
    }

    function collect(uint amount) public {
        require(balances[msg.sender] >= minSum && balances[msg.sender] >= amount && now > unlockTimes[msg.sender]);
        balances[msg.sender] -= amount;
        require(msg.sender.call.value(amount)());
        log.addMessage(msg.sender, amount, "Collect");
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

    function addMessage(address sender, uint value, string data) public {
        Message memory newMessage = Message(sender, data, value, now);
        history.push(newMessage);
    }
}