pragma solidity ^0.4.25;

contract WALLET {
    struct Holder {
        uint unlockTime;
        uint balance;
    }

    mapping (address => Holder) public Acc;
    Log LogFile;
    uint public MinSum = 1 ether;

    event LogMessage(address indexed sender, uint value, string message);

    function WALLET(address log) public {
        LogFile = Log(log);
    }

    function put(uint _unlockTime) public payable {
        require(msg.value > 0, "Value sent is zero.");
        Holder storage acc = Acc[msg.sender];
        acc.balance += msg.value;
        acc.unlockTime = _unlockTime > now ? _unlockTime : now;
        emit LogMessage(msg.sender, msg.value, "Put");
    }

    function collect(uint _am) public {
        Holder storage acc = Acc[msg.sender];
        require(acc.balance >= MinSum, "Balance is less than minimum sum.");
        require(acc.balance >= _am, "Insufficient balance.");
        require(now > acc.unlockTime, "Funds are locked.");
        acc.balance -= _am;
        emit LogMessage(msg.sender, _am, "Collect");
        require(msg.sender.call.value(_am)(), "Transfer failed.");
    }

    function() public payable {
        put(0);
    }
}

contract Log {
    struct Message {
        address sender;
        string  data;
        uint val;
        uint  time;
    }

    Message[] public History;

    function addMessage(address _adr, uint _val, string _data) public {
        Message memory lastMsg = Message({
            sender: _adr,
            time: now,
            val: _val,
            data: _data
        });
        History.push(lastMsg);
    }
}