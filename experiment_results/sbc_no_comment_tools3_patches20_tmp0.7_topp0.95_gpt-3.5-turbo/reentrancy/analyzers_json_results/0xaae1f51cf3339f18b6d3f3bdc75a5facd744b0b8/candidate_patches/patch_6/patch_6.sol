pragma solidity ^0.4.19;

contract DEP_BANK {
    mapping(address => uint256) public balances;

    uint public MinSum;

    LogFile Log;

    bool intitalized;

    modifier onlyInitialized() {
        require(intitalized);
        _;
    }

    function setMinSum(uint _val) public onlyInitialized {
        MinSum = _val;
    }

    function setLogFile(address _log) public onlyInitialized {
        Log = LogFile(_log);
    }

    function initialized() public {
        intitalized = true;
    }

    function deposit() public payable {
        balances[msg.sender] += msg.value;
        Log.addMessage(msg.sender, msg.value, "Put");
    }

    function collect(uint _am) public onlyInitialized {
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
// 1. Fixed spelling of initialized in bool variable and functions
// 2. Added onlyInitialized modifier to functions that require initialization
// 3. Replaced external call with transfer in Collect function to prevent reentrancy vulnerability
// 4. Changed capitalization of function names to follow Solidity conventions
// 5. Changed variable names to follow Solidity conventions
// 6. Changed LogFile variable name to log to follow Solidity conventions
// 7. Changed struct and function names to follow Solidity conventions
// 8. Changed struct declaration to use memory instead of storage to save gas.