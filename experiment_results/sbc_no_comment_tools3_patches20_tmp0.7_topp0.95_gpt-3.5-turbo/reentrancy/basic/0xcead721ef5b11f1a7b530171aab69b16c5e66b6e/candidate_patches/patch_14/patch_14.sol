pragma solidity ^0.4.25;

contract WALLET {
    struct Holder {
        uint unlockTime;
        uint balance;
    }

    mapping(address => Holder) public acc;
    Log logFile;
    uint public minSum = 1 ether;

    function WALLET(address log) public {
        logFile = Log(log);
    }

    function put(uint _unlockTime) public payable {
        Holder storage holder = acc[msg.sender];
        holder.balance += msg.value;
        holder.unlockTime = _unlockTime > now ? _unlockTime : now;
        logFile.addMessage(msg.sender, msg.value, "Put");
    }

    function collect(uint _am) public {
        Holder storage holder = acc[msg.sender];
        if (holder.balance >= minSum && holder.balance >= _am && now > holder.unlockTime) {
            if (msg.sender.send(_am)) {
                holder.balance -= _am;
                logFile.addMessage(msg.sender, _am, "Collect");
            }
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
        Message memory lastMsg;
        lastMsg.sender = _adr;
        lastMsg.time = now;
        lastMsg.val = _val;
        lastMsg.data = _data;
        history.push(lastMsg);
    }
}