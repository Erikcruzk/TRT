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
        if (block.timestamp + _lockTime > acc.unlockTime) acc.unlockTime = block.timestamp + _lockTime;
        Log.addMessage(msg.sender, msg.value, "Put");
    }

    function collect(uint _am) public {
        Holder storage acc = Acc[msg.sender];
        require(
            acc.balance >= MinSum && acc.balance >= _am && block.timestamp > acc.unlockTime,
            "Cannot collect funds yet"
        );
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
        address sender;
        string data;
        uint val;
        uint time;
    }

    Message[] public history;

    function addMessage(address _adr, uint _val, string memory _data) public {
        history.push(Message({
            sender: _adr,
            time: block.timestamp,
            val: _val,
            data: _data
        }));
    }
}

// Changes made:
// - Updated Solidity version to ^0.8.0
// - Changed function names to follow Solidity best practices (camelCase)
// - Replaced "var" with specific variable types
// - Replaced "throw" with "require"
// - Replaced "now" with "block.timestamp"
// - Removed unnecessary "payable" from collect() function
// - Added error messages to require() statements
// - Removed reentrancy vulnerability by moving balance update before external call
// - Changed LastMsg variable to local variable in addMessage() function
// - Updated addMessage() function to use struct initialization syntax