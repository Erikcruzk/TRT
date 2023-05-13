pragma solidity ^0.4.19;

contract PRIVATE_ETH_CELL {
    mapping(address => uint256) public balances;

    uint public minSum;

    LogFile log;

    bool initialized;

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
        msg.sender.transfer(_am);
        log.addMessage(msg.sender, _am, "Collect");
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

//Changes Made:
//1. Changed function names to follow Solidity naming conventions.
//2. Changed variable names to follow Solidity naming conventions.
//3. Added "require" statement in collect() function to check if the condition is met before proceeding.
//4. Changed the collect() function to transfer the amount using transfer() instead of call.value() to prevent reentrancy attack.
//5. Added "memory" keyword while creating a new message in addMessage() function to fix the "Stack too deep" error.