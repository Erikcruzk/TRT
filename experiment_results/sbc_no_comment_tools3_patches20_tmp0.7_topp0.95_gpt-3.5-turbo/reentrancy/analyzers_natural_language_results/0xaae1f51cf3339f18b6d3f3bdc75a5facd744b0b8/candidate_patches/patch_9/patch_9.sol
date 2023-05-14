pragma solidity ^0.4.19;

contract DEP_BANK {
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

    function initialized() public {
        initialized = true;
    }

    function deposit() public payable {
        balances[msg.sender] += msg.value;
        log.addMessage(msg.sender, msg.value, "Put");
    }

    function collect(uint _am) public {
        require(balances[msg.sender] >= minSum && balances[msg.sender] >= _am);
        balances[msg.sender] -= _am;
        if (!msg.sender.send(_am)) {
            balances[msg.sender] += _am;
            revert();
        }
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
        history.push(Message({
            sender: _adr,
            time: now,
            val: _val,
            data: _data
        }));
    }
} 

// Changes Made
// 1. Renamed MinSum to minSum to follow Solidity naming conventions.
// 2. Changed throw to require to handle errors gracefully.
// 3. Removed payable modifier from collect function as it is not required.
// 4. Reordered the code to follow best practices, such as putting state variables on top.
// 5. Updated the collect function to prevent reentrancy attacks.
// 6. Renamed Log to log to follow Solidity naming conventions.
// 7. Updated LogFile to use struct initialization shorthand.