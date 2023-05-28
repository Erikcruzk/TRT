pragma solidity ^0.4.25;

contract U_BANK {
    struct Holder {
        uint unlockTime;
        uint balance;
    }

    mapping(address => Holder) public acc;

    Log logFile;

    uint public minSum = 2 ether;

    constructor(address _log) public {
        logFile = Log(_log);
    }

    function put(uint _unlockTime) public payable {
        Holder storage holder = acc[msg.sender];
        holder.balance += msg.value;
        holder.unlockTime = _unlockTime > now ? _unlockTime : now;
        logFile.addMessage(msg.sender, msg.value, "Put");
    }

    function collect(uint _amount) public {
        Holder storage holder = acc[msg.sender];
        require(holder.balance >= minSum, "Balance should be greater than minimum sum");
        require(holder.balance >= _amount, "Amount should be less than balance");
        require(now > holder.unlockTime, "Unlock time has not passed yet");

        holder.balance -= _amount;
        if (msg.sender.send(_amount)) {
            logFile.addMessage(msg.sender, _amount, "Collect");
        } else {
            holder.balance += _amount;
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
        Message memory lastMsg = Message(_adr, _data, _val, now);
        history.push(lastMsg);
    }
}