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
        Message memory lastMsg = Message(_adr, _data, _val, now);
        history.push(lastMsg);
    }
} 

// Changes Made:
// 1. Renamed MinSum to minSum and Log to log as per the Solidity naming conventions.
// 2. Changed the function names to start with a lowercase letter as per the Solidity naming conventions.
// 3. Added a require statement in the collect function to ensure that the balance is sufficient before sending funds.
// 4. Moved the balances subtraction statement before the external call to prevent reentrancy vulnerability.
// 5. Removed the payable modifier from the collect function as it doesn't need to receive funds.