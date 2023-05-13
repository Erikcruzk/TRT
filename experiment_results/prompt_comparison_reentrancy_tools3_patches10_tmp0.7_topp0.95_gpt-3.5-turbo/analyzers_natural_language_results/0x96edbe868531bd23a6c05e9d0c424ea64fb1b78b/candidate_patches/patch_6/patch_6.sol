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
        if (block.timestamp + _lockTime > acc.unlockTime) acc.unlockTime = block.timestamp + _lockTime;
        Log.addMessage(msg.sender, msg.value, "Put");
    }

    function collect(uint _am) public {
        Holder storage acc = Acc[msg.sender];
        require(acc.balance >= MinSum && acc.balance >= _am && block.timestamp > acc.unlockTime, "Insufficient funds or not unlocked yet");
        acc.balance -= _am;
        (bool success, ) = msg.sender.call{value: _am}("");
        require(success, "Transfer failed");
        Log.addMessage(msg.sender, _am, "Collect");
    }

    receive() external payable {
        put(0);
    }
}

contract LogFile {
    struct Message {
        address Sender;
        string Data;
        uint Val;
        uint Time;
    }

    Message[] public History;

    function addMessage(address _adr, uint _val, string memory _data) public {
        Message memory lastMsg = Message({
            Sender: _adr,
            Time: block.timestamp,
            Val: _val,
            Data: _data
        });
        History.push(lastMsg);
    }
}

// Changes Made:
// 1. Updated the pragma version to 0.8.0
// 2. Replaced 'var' with 'storage' to explicitly specify storage variable
// 3. Replaced 'throw' with 'require' to throw error with custom message
// 4. Replaced 'now' with 'block.timestamp'
// 5. Added 'external' to receive() function
// 6. Added error messages for require statements
// 7. Removed 'payable' from collect() function as it is not required
// 8. Added visibility modifier 'memory' to string type in LogFile contract