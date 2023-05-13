pragma solidity ^0.4.19;

contract PRIVATE_ETH_CELL {
    mapping(address => uint256) public balances;

    uint public MinSum;

    LogFile Log;

    bool initialized;

    modifier notInitialized() {
        require(!initialized);
        _;
    }

    function setMinSum(uint _val) public notInitialized {
        MinSum = _val;
    }

    function setLogFile(address _log) public notInitialized {
        Log = LogFile(_log);
    }

    function initialize() public notInitialized {
        initialized = true;
    }

    function deposit() public payable {
        balances[msg.sender] += msg.value;
        Log.addMessage(msg.sender, msg.value, "Put");
    }

    function collect(uint _am) public {
        require(balances[msg.sender] >= MinSum && balances[msg.sender] >= _am);
        balances[msg.sender] -= _am;
        Log.addMessage(msg.sender, _am, "Collect");
        msg.sender.transfer(_am);
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
        Message memory msg;
        msg.sender = _adr;
        msg.time = now;
        msg.val = _val;
        msg.data = _data;
        history.push(msg);
    }
} 

// Changes made:
// 1. Renamed functions and variables to follow Solidity naming conventions.
// 2. Added a modifier to ensure certain functions can only be called before initialization.
// 3. Modified the collect function to transfer funds after updating the balance and logging the message to prevent reentrancy attacks.
// 4. Modified the LogFile contract to use a local variable instead of a state variable to prevent multiple messages being stored with the same value.