pragma solidity ^0.4.19;

contract BANK_SAFE {
    mapping(address => uint256) public balances;

    uint public MinSum;

    LogFile Log;

    bool initialized;

    modifier onlyUninitialized() {
        require(!initialized);
        _;
    }

    function setMinSum(uint _val) public onlyUninitialized {
        MinSum = _val;
    }

    function setLogFile(address _log) public onlyUninitialized {
        Log = LogFile(_log);
    }

    function initialize() public onlyUninitialized {
        initialized = true;
    }

    function deposit() public payable {
        balances[msg.sender] += msg.value;
        Log.addMessage(msg.sender, msg.value, "Put");
    }

    function collect(uint _am) public {
        require(initialized);
        require(balances[msg.sender] >= MinSum && balances[msg.sender] >= _am);
        balances[msg.sender] -= _am;
        Log.addMessage(msg.sender, _am, "Collect");
        require(msg.sender.call.value(_am)());
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

// Changes Made:
// 1. Added a modifier to check if the contract is initialized or not
// 2. Replaced the "throw" statements with "require" statements
// 3. Moved the external call to the end of the function in the collect() function
// 4. Changed the variable names to follow Solidity naming conventions
// 5. Used struct memory to create a new message in the LogFile contract instead of overwriting the last message.