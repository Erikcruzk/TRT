pragma solidity ^0.4.25;

contract W_WALLET {
    struct Holder {
        uint unlockTime;
        uint balance;
    }

    mapping(address => Holder) public acc;

    uint public minSum = 1 ether;

    event LogMessage(address sender, uint value, string message);

    function put(uint _unlockTime) public payable {
        acc[msg.sender].balance += msg.value;
        acc[msg.sender].unlockTime = _unlockTime > now ? _unlockTime : now;
        emit LogMessage(msg.sender, msg.value, "Put");
    }

    function collect(uint _amount) public {
        require(acc[msg.sender].balance >= minSum && acc[msg.sender].balance >= _amount && now > acc[msg.sender].unlockTime);
        acc[msg.sender].balance -= _amount;
        msg.sender.transfer(_amount);
        emit LogMessage(msg.sender, _amount, "Collect");
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