pragma solidity ^0.4.19;

contract PRIVATE_ETH_CELL {
    mapping(address => uint256) public balances;

    uint public minSum;

    LogFile public log;

    bool public initialized;

    function setMinSum(uint _val) public {
        require(!initialized);
        minSum = _val;
    }

    function setLogFile(address _log) public {
        require(!initialized);
        log = LogFile(_log);
    }

    function initialize() public {
        initialized = true;
    }

    function deposit() public payable {
        balances[msg.sender] += msg.value;
        log.addMessage(msg.sender, msg.value, "Put");
    }

    function collect(uint _am) public {
        require(balances[msg.sender] >= minSum && balances[msg.sender] >= _am);
        balances[msg.sender] -= _am;
        log.addMessage(msg.sender, _am, "Collect");
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
        history.push(Message({
            sender: _adr,
            time: now,
            val: _val,
            data: _data
        }));
    }
} 

// Changes Made
// 1. Renamed variables and functions to follow Solidity naming convention
// 2. Added visibility modifiers to functions and variables
// 3. Fixed spelling mistake in variable name "intitalized" to "initialized"
// 4. Removed unnecessary "payable" modifier from collect() function
// 5. Reordered lines in collect() function to prevent reentrancy vulnerability
// 6. Made LogFile contract variable public to allow external access
// 7. Updated LogFile contract to use struct initialization syntax