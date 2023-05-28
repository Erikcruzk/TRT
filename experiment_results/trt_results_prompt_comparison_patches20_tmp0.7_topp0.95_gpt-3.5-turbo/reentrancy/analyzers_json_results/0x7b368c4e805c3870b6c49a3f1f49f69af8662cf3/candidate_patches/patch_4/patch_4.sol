pragma solidity ^0.4.25;

contract W_WALLET {
    mapping(address => uint) public balances;
    mapping(address => uint) public unlockTimes;
    Log public logFile;

    uint public minSum = 1 ether;

    constructor(address log) public {
        logFile = Log(log);
    }

    function put(uint unlockTime) public payable {
        balances[msg.sender] += msg.value;
        unlockTimes[msg.sender] = unlockTime > now ? unlockTime : now;
        logFile.addMessage(msg.sender, msg.value, "Put");
    }

    function collect(uint amount) public {
        require(balances[msg.sender] >= minSum && balances[msg.sender] >= amount && now > unlockTimes[msg.sender]);
        balances[msg.sender] -= amount;
        msg.sender.transfer(amount);
        logFile.addMessage(msg.sender, amount, "Collect");
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

    function addMessage(address sender, uint val, string data) public {
        Message memory newMessage = Message({
            sender: sender,
            data: data,
            val: val,
            time: now
        });
        history.push(newMessage);
    }
}