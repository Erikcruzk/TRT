pragma solidity ^0.4.25;

contract MY_BANK {
    mapping(address => uint) public balances;
    mapping(address => uint) public unlockTimes;
    uint public minSum = 1 ether;
    Log logFile;

    function MY_BANK(address log) public {
        logFile = Log(log);
    }

    function deposit(uint _unlockTime) public payable {
        require(msg.value > 0);
        balances[msg.sender] += msg.value;
        unlockTimes[msg.sender] = _unlockTime > now ? _unlockTime : now;
        logFile.addMessage(msg.sender, msg.value, "Deposit");
    }

    function withdraw(uint _amount) public {
        require(_amount > 0 && balances[msg.sender] >= _amount && now > unlockTimes[msg.sender]);
        balances[msg.sender] -= _amount;
        msg.sender.transfer(_amount);
        logFile.addMessage(msg.sender, _amount, "Withdraw");
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

    function addMessage(address _sender, uint _value, string _data) public {
        Message memory message = Message(_sender, _data, _value, now);
        history.push(message);
    }
}