pragma solidity ^0.4.19;

contract PRIVATE_ETH_CELL {
    mapping(address => uint256) public balances;

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

    function deposit() public payable {
        balances[msg.sender] += msg.value;
        Log.addMessage(msg.sender, msg.value, "Put");
    }

    function collect(uint _am) public {
        if (balances[msg.sender] >= MinSum && balances[msg.sender] >= _am) {
            balances[msg.sender] -= _am;
            Log.addMessage(msg.sender, _am, "Collect");
            require(msg.sender.send(_am));
        }
    }

    function() public payable {
        deposit();
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
        Message memory newMsg = Message({
            sender: _adr,
            time: now,
            val: _val,
            data: _data
        });
        history.push(newMsg);
    }
} 

// Changes made:
// 1. Changed function and variable names to follow Solidity naming conventions
// 2. Initialized bool variable corrected to initialized
// 3. Added require statement to check if send() function call was successful in collect() function
// 4. Added memory keyword while creating a new message in LogFile contract to avoid storage allocation errors
// 5. Changed struct variable names to follow Solidity naming conventions