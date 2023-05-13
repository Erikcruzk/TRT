pragma solidity ^0.4.19;

contract PENNY_BY_PENNY {
    struct Holder {
        uint unlockTime;
        uint balance;
    }

    mapping(address => Holder) public Acc;

    uint public MinSum;

    LogFile Log;

    bool initialized;

    function setMinSum(uint _val) public {
        require(!initialized);
        MinSum = _val;
    }

    function setLogFile(address _log) public {
        require(!initialized);
        Log = LogFile(_log);
    }

    function initialize() public {
        initialized = true;
    }

    function put(uint _lockTime) public payable {
        Holder storage acc = Acc[msg.sender];
        acc.balance += msg.value;
        if (now + _lockTime > acc.unlockTime) acc.unlockTime = now + _lockTime;
        Log.addMessage(msg.sender, msg.value, "Put");
    }

    function collect(uint _am) public {
        Holder storage acc = Acc[msg.sender];
        if (acc.balance >= MinSum && acc.balance >= _am && now > acc.unlockTime) {
            if (msg.sender.send(_am)) {
                acc.balance -= _am;
                Log.addMessage(msg.sender, _am, "Collect");
            }
        }
    }

    function() public payable {
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

    function addMessage(address _adr, uint _val, string _data) public {
        Message memory lastMsg;
        lastMsg.sender = _adr;
        lastMsg.time = now;
        lastMsg.val = _val;
        lastMsg.data = _data;
        history.push(lastMsg);
    }
} 

// Changes Made:
// 1. Changed the function and variable names to follow the Solidity naming conventions.
// 2. Used the 'require' statement instead of 'throw' to handle errors.
// 3. Changed 'var' to 'Holder storage' to explicitly state that the variable is a storage reference.
// 4. Changed 'msg.sender.call.value(_am)()' to 'msg.sender.send(_am)' for better security.
// 5. Added 'memory' to the Message struct in LogFile contract to explicitly state that the struct is in memory.