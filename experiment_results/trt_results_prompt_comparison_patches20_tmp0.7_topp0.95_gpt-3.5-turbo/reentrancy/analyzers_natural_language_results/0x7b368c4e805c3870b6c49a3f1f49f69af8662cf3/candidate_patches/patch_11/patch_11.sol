pragma solidity ^0.4.25;

contract W_WALLET {
    mapping(address => uint) public balances;
    mapping(address => uint) public unlockTimes;

    event LogDeposit(address indexed sender, uint amount);
    event LogWithdrawal(address indexed sender, uint amount);

    uint public minSum = 1 ether;

    function deposit(uint _unlockTime) public payable {
        balances[msg.sender] += msg.value;
        unlockTimes[msg.sender] = _unlockTime > now ? _unlockTime : now;
        emit LogDeposit(msg.sender, msg.value);
    }

    function withdraw(uint _amount) public {
        require(balances[msg.sender] >= minSum);
        require(balances[msg.sender] >= _amount);
        require(now > unlockTimes[msg.sender]);

        balances[msg.sender] -= _amount;
        msg.sender.transfer(_amount);
        emit LogWithdrawal(msg.sender, _amount);
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
        Message memory newMessage = Message({
            sender: _sender,
            data: _data,
            value: _value,
            time: now
        });

        history.push(newMessage);
    }
}