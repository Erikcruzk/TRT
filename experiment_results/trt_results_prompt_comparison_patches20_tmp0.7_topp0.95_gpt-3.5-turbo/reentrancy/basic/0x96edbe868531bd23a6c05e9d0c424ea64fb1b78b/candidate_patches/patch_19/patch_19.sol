pragma solidity ^0.8.0;

contract PENNY_BY_PENNY {
    struct Holder {
        uint unlockTime;
        uint balance;
    }

    mapping(address => Holder) public Acc;

    uint public MinSum;

    LogFile Log;

    bool initialized;

    constructor() {
        initialized = false;
    }

    function setMinSum(uint _val) public {
        require(!initialized, "Already initialized");
        MinSum = _val;
    }

    function setLogFile(address _log) public {
        require(!initialized, "Already initialized");
        Log = LogFile(_log);
    }

    function initialize() public {
        initialized = true;
    }

    function put(uint _lockTime) public payable {
        Holder storage acc = Acc[msg.sender];
        acc.balance += msg.value;
        if (block.timestamp + _lockTime > acc.unlockTime) {
            acc.unlockTime = block.timestamp + _lockTime;
        }
        Log.addMessage(msg.sender, msg.value, "Put");
    }

    function collect(uint _am) public payable {
        Holder storage acc = Acc[msg.sender];
        if (acc.balance >= MinSum && acc.balance >= _am && block.timestamp > acc.unlockTime) {
            if (payable(msg.sender).send(_am)) {
                acc.balance -= _am;
                Log.addMessage(msg.sender, _am, "Collect");
            }
        }
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
        Message memory lastMsg;
        lastMsg.sender = _adr;
        lastMsg.time = block.timestamp;
        lastMsg.val = _val;
        lastMsg.data = _data;
        history.push(lastMsg);
    }
}