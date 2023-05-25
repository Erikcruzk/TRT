pragma solidity ^0.4.25;

contract X_WALLET {
    mapping(address => uint) public balances;
    mapping(address => uint) public unlockTimes;
    uint public minSum = 1 ether;
    Log logContract;

    constructor(address log) public {
        logContract = Log(log);
    }

    function deposit(uint _unlockTime) public payable {
        balances[msg.sender] += msg.value;
        unlockTimes[msg.sender] = _unlockTime > now ? _unlockTime : now;
        logContract.addMessage(msg.sender, msg.value, "Deposit");
    }

    function withdraw(uint _amount) public {
        require(balances[msg.sender] >= minSum && balances[msg.sender] >= _amount && now > unlockTimes[msg.sender]);
        balances[msg.sender] -= _amount;
        msg.sender.transfer(_amount);
        logContract.addMessage(msg.sender, _amount, "Withdraw");
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
        history.push(Message(_sender, _data, _value, now));
    }
}