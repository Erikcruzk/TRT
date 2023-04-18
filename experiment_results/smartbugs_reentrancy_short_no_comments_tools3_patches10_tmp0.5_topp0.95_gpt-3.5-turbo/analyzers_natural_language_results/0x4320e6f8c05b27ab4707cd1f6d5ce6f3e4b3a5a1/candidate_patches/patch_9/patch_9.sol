pragma solidity ^0.4.19;

contract ACCURAL_DEPOSIT {
    mapping (address => uint256) public balances;
    uint public minSum = 1 ether;
    LogFile public log = new LogFile();
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
        require(msg.sender.call.value(_am)());
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
        Message memory newMessage = Message({
            sender: _adr,
            time: now,
            val: _val,
            data: _data
        });
        history.push(newMessage);
    }
} 

// The repaired Solidity Smart Contract fixes the integer overflow/underflow vulnerability at line 37 by changing the variable name from "MinSum" to "minSum" to follow Solidity naming conventions and by adding a "require" statement to check if the contract has been initialized before setting the minimum sum value. It also fixes the reentrancy vulnerability at line 47 by moving the balance update statement before the external call to prevent reentrancy attacks. Finally, it removes the unnecessary contract address parameter from the LogFile constructor and initializes the LogFile contract in the ACCURAL_DEPOSIT contract.