pragma solidity ^0.4.25;

contract U_BANK {
    mapping(address => Holder) public Acc;

    Log LogFile;

    uint public MinSum = 2 ether;

    struct Holder {
        uint unlockTime;
        uint balance;
        bool isHolder;
    }

    function U_BANK(address log) public {
        LogFile = Log(log);
    }

    function put(uint _unlockTime) public payable {
        require(msg.value > 0);
        Holder storage acc = Acc[msg.sender];
        acc.balance += msg.value;
        acc.unlockTime = _unlockTime > now ? _unlockTime : now;
        if (!acc.isHolder) {
            acc.isHolder = true;
        }
        LogFile.addMessage(msg.sender, msg.value, "Put");
    }

    function collect(uint _am) public {
        require(_am > 0);
        Holder storage acc = Acc[msg.sender];
        require(acc.isHolder);
        require(acc.balance >= MinSum && acc.balance >= _am && now > acc.unlockTime);
        acc.balance -= _am;
        msg.sender.transfer(_am);
        LogFile.addMessage(msg.sender, _am, "Collect");
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
        Message memory newMsg = Message({
            sender: _adr,
            time: now,
            val: _val,
            data: _data
        });
        history.push(newMsg);
    }
}