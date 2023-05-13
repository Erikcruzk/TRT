pragma solidity ^0.8.0;

contract DEP_BANK {
    mapping(address => uint256) public balances;

    uint public minSum;

    LogFile log;

    bool initialized;

    function setMinSum(uint _val) public {
        require(!initialized, "Already initialized");
        minSum = _val;
    }

    function setLogFile(address _log) public {
        require(!initialized, "Already initialized");
        log = LogFile(_log);
    }

    function initialized() public {
        initialized = true;
    }

    function deposit() public payable {
        balances[msg.sender] += msg.value;
        log.addMessage(msg.sender, msg.value, "Put");
    }

    function collect(uint _am) public payable {
        require(balances[msg.sender] >= minSum && balances[msg.sender] >= _am, "Insufficient balance");
        balances[msg.sender] -= _am;
        log.addMessage(msg.sender, _am, "Collect");
        (bool success, ) = msg.sender.call{value: _am}("");
        require(success, "Transfer failed");
    }

    receive() external payable {
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

    function addMessage(address _adr, uint _val, string memory _data) public {
        Message memory lastMsg = Message(_adr, _data, _val, block.timestamp);
        history.push(lastMsg);
    }
}

// Changes Made:
// 1. Changed the Solidity version to ^0.8.0
// 2. Changed all variables starting with capital letters to camelCase format
// 3. Used require instead of if statements and added error messages
// 4. Added a check for the success of the external call in collect() function
// 5. Changed the function name from Initialized() to initialized()
// 6. Changed the LogFile struct variable name from LastMsg to lastMsg and made it a memory variable before use.