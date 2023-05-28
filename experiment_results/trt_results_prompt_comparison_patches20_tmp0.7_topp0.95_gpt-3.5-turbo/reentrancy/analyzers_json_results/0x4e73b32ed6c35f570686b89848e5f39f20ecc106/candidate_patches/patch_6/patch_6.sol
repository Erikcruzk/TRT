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

    function initialize() public {
        initialized = true;
    }

    function deposit() public payable {
        balances[msg.sender] += msg.value;
        Log.addMessage(msg.sender, msg.value, "Put");
    }

    function collect(uint _am) public payable {
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
// 1. Made the contract names consistent with their filenames
// 2. Changed function and variable names to follow Solidity naming conventions
// 3. Added a modifier to check if the contract is initialized before executing certain functions
// 4. Changed the Collect function to first update the balances mapping and Log before making the external call to prevent re-entrancy vulnerability
// 5. Changed the LogFile struct to use memory instead of storage to save gas
// 6. Removed unnecessary variables and functions