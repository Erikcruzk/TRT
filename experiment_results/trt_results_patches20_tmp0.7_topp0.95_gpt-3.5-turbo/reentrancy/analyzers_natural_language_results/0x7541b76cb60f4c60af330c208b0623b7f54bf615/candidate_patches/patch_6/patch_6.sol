pragma solidity ^0.4.25;

contract U_BANK {
    mapping(address => Holder) public Acc;
    uint public MinSum = 2 ether;
    Log LogFile;

    struct Holder {
        uint unlockTime;
        uint balance;
    }

    constructor(address log) public {
        LogFile = Log(log);
    }

    function Put(uint _unlockTime) public payable {
        Acc[msg.sender].balance += msg.value;
        Acc[msg.sender].unlockTime = _unlockTime > now ? _unlockTime : now;
        LogFile.AddMessage(msg.sender, msg.value, "Put");
    }

    function Collect(uint _am) public {
        require(Acc[msg.sender].balance >= MinSum, "Insufficient balance");
        require(Acc[msg.sender].balance >= _am, "Amount exceeds balance");
        require(now > Acc[msg.sender].unlockTime, "Funds are locked");

        Acc[msg.sender].balance -= _am;
        LogFile.AddMessage(msg.sender, _am, "Collect");

        msg.sender.transfer(_am);
    }

    function() public payable {
        Put(0);
    }
}

contract Log {
    struct Message {
        address sender;
        string data;
        uint val;
        uint time;
    }

    Message[] public History;

    function AddMessage(address _adr, uint _val, string _data) public {
        Message memory lastMsg = Message(_adr, _data, _val, now);
        History.push(lastMsg);
    }
}