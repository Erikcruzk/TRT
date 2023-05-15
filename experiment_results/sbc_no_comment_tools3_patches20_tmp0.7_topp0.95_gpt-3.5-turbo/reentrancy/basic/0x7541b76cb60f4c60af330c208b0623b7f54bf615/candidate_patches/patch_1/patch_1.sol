pragma solidity ^0.4.25;

contract U_BANK {
    struct Holder {
        uint unlockTime;
        uint balance;
    }
    
    mapping(address => Holder) public Acc;
    Log LogFile;
    uint public MinSum = 2 ether;

    constructor(address log) public {
        LogFile = Log(log);
    }

    function Put(uint _unlockTime) public payable {
        require(msg.value > 0, "Amount should be greater than zero");
        Holder storage acc = Acc[msg.sender];
        acc.balance += msg.value;
        acc.unlockTime = _unlockTime > now ? _unlockTime : now;
        LogFile.AddMessage(msg.sender, msg.value, "Put");
    }

    function Collect(uint _am) public {
        Holder storage acc = Acc[msg.sender];
        require(acc.balance >= MinSum, "Balance should be greater than or equal to minimum sum");
        require(acc.balance >= _am, "Amount should be less than or equal to balance");
        require(now > acc.unlockTime, "Account is locked");
        acc.balance -= _am;
        require(msg.sender.call.value(_am)(), "Transaction failed");
        LogFile.AddMessage(msg.sender, _am, "Collect");
    }

    function() public payable {
        Put(0);
    }
}

contract Log {
    struct Message {
        address Sender;
        string Data;
        uint Val;
        uint Time;
    }

    Message[] public History;

    function AddMessage(address _adr, uint _val, string _data) public {
        Message memory newMessage = Message({
            Sender: _adr,
            Time: now,
            Val: _val,
            Data: _data
        });
        History.push(newMessage);
    }
}