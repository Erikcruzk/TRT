pragma solidity ^0.4.25;

contract W_WALLET {
    mapping(address => uint) public balanceOf;
    mapping(address => uint) public unlockTimeOf;
    Log public log;

    uint public minSum = 1 ether;

    function W_WALLET(address logAddress) public {
        log = Log(logAddress);
    }

    function deposit(uint unlockTime) public payable {
        balanceOf[msg.sender] += msg.value;
        unlockTimeOf[msg.sender] = unlockTime > now ? unlockTime : now;
        log.addMessage(msg.sender, msg.value, "Deposit");
    }

    function withdraw(uint amount) public {
        require(balanceOf[msg.sender] >= minSum);
        require(balanceOf[msg.sender] >= amount);
        require(now > unlockTimeOf[msg.sender]);
        balanceOf[msg.sender] -= amount;
        if(msg.sender.call.value(amount)()) {
            log.addMessage(msg.sender, amount, "Withdraw");
        }
    }

    function() public payable {
        deposit(0);
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
        Message memory newMessage;
        newMessage.sender = sender;
        newMessage.time = now;
        newMessage.value = value;
        newMessage.data = data;
        history.push(newMessage);
    }
}