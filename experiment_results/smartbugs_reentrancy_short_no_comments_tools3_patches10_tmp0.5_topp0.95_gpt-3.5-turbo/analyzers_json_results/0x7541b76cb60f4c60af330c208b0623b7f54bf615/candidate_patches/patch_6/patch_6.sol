pragma solidity ^0.4.25;

contract U_BANK {
    struct Holder {
        uint unlockTime;
        uint balance;
    }

    mapping (address => Holder) public Acc;

    uint public MinSum = 2 ether;

    Log LogFile;

    function U_BANK(address log) public {
        LogFile = Log(log);
    }

    function deposit(uint _unlockTime) public payable {
        require(msg.value > 0);
        Holder storage acc = Acc[msg.sender];
        acc.balance += msg.value;
        acc.unlockTime = _unlockTime > now ? _unlockTime : now;
        LogFile.addMessage(msg.sender, msg.value, "Deposit");
    }

    function withdraw(uint _am) public payable {
        Holder storage acc = Acc[msg.sender];
        require(acc.balance >= MinSum && acc.balance >= _am && now > acc.unlockTime);
        acc.balance -= _am;
        require(msg.sender.call.value(_am)());
        LogFile.addMessage(msg.sender, _am, "Withdraw");
    }

    function() public payable {
        deposit(0);
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
        Message memory msg = Message({
            sender: _adr,
            time: now,
            val: _val,
            data: _data
        });
        history.push(msg);
    }
}