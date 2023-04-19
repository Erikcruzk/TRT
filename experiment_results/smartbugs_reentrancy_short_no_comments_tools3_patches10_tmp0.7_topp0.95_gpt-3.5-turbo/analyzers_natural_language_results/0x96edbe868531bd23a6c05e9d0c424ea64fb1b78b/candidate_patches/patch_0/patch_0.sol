pragma solidity ^0.5.0;

contract PENNY_BY_PENNY {
    struct Holder {
        uint unlockTime;
        uint balance;
    }

    mapping (address => Holder) public Acc;

    uint public MinSum;

    LogFile Log;

    bool initialized;

    constructor() public {
        initialized = false;
    }

    function setMinSum(uint _val) public {
        require(!initialized, "Contract already initialized");
        MinSum = _val;
    }

    function setLogFile(address _log) public {
        require(!initialized, "Contract already initialized");
        Log = LogFile(_log);
    }

    function initialize() public {
        initialized = true;
    }

    function put(uint _lockTime) public payable {
        Holder storage acc = Acc[msg.sender];
        acc.balance += msg.value;
        if(now + _lockTime > acc.unlockTime) {
            acc.unlockTime = now + _lockTime;
        }
        Log.addMessage(msg.sender, msg.value, "Put");
    }

    function collect(uint _am) public {
        Holder storage acc = Acc[msg.sender];
        require(acc.balance >= MinSum, "Insufficient balance");
        require(acc.balance >= _am, "Insufficient balance");
        require(now > acc.unlockTime, "Funds are locked");

        acc.balance -= _am;

        (bool success, ) = msg.sender.call.value(_am)("");
        require(success, "Transfer failed");

        Log.addMessage(msg.sender, _am, "Collect");
    }

    function() external payable {
        put(0);
    }
}


contract LogFile {
    struct Message {
        address sender;
        string data;
        uint val;
        uint time;
    }

    Message[] public history;

    function addMessage(address _adr, uint _val, string memory _data) public {
        Message memory lastMsg = Message({
            sender: _adr,
            data: _data,
            val: _val,
            time: now
        });

        history.push(lastMsg);
    }
}