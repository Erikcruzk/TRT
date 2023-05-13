pragma solidity ^0.4.19;

contract PERSONAL_BANK {
    mapping(address => uint256) public balances;

    uint public MinSum = 1 ether;

    LogFile public Log;

    bool initialized;

    function setMinSum(uint _val) public {
        require(!initialized);
        MinSum = _val;
    }

    function setLogFile(LogFile _log) public {
        require(!initialized);
        Log = _log;
    }

    function initialize() public {
        initialized = true;
    }

    function deposit() public payable {
        balances[msg.sender] += msg.value;
        Log.addMessage(msg.sender, msg.value, "Put");
    }

    function collect(uint _am) public {
        require(balances[msg.sender] >= MinSum && balances[msg.sender] >= _am);
        balances[msg.sender] -= _am;
        require(msg.sender.call.value(_am)());
        Log.addMessage(msg.sender, _am, "Collect");
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
        Message memory newMessage = Message({
            sender: _adr,
            time: now,
            val: _val,
            data: _data
        });
        history.push(newMessage);
    }
} 

// Changes made:
// 1. Changed function names to follow Solidity naming conventions
// 2. Changed LogFile contract address to LogFile contract instance
// 3. Removed unnecessary payable modifier from collect function
// 4. Reordered statements in collect function to prevent reentrancy vulnerability
// 5. Removed unnecessary initialized variable check in deposit and collect functions and replaced with require statements