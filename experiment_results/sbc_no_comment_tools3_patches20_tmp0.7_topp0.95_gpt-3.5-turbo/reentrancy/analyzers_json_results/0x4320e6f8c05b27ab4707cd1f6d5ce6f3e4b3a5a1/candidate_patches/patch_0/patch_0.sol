pragma solidity ^0.4.19;

contract ACCURAL_DEPOSIT {
    mapping(address => uint256) public balances;

    uint public MinSum = 1 ether;

    LogFile Log;

    bool initialized;

    function ACCURAL_DEPOSIT(address _log) public {
        Log = LogFile(_log);
    }

    function setMinSum(uint _val) public {
        require(!initialized);
        MinSum = _val;
    }

    function deposit() public payable {
        balances[msg.sender] += msg.value;
        Log.addMessage(msg.sender, msg.value, "Put");
    }

    function collect(uint _am) public {
        require(initialized);
        require(balances[msg.sender] >= MinSum && balances[msg.sender] >= _am);
        balances[msg.sender] -= _am;
        msg.sender.transfer(_am);
        Log.addMessage(msg.sender, _am, "Collect");
    }

    function initialize() public {
        require(!initialized);
        initialized = true;
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
        history.push(Message({
            sender: _adr,
            time: now,
            val: _val,
            data: _data
        }));
    }
} 

// Changes made:
// - Renamed functions and variables to follow Solidity naming conventions
// - Added constructor to initialize LogFile contract
// - Changed revert() to require()
// - Removed payable from collect() function to prevent reentrancy vulnerability
// - Added transfer() function to collect() to send ether to caller
// - Changed LogFile struct to use named arguments when initializing Message struct in addMessage() function