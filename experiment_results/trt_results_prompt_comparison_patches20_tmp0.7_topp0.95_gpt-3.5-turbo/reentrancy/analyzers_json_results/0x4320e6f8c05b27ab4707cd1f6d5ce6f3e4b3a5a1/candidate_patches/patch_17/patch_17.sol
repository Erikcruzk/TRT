pragma solidity ^0.4.19;

contract ACCURAL_DEPOSIT {
    mapping(address => uint256) public balances;

    uint public MinSum = 1 ether;

    LogFile public Log;

    bool public initialized;

    function setMinSum(uint _val) public {
        require(!initialized);
        MinSum = _val;
    }

    function setLogFile(LogFile _log) public {
        require(!initialized);
        Log = _log;
    }

    function initialize() public {
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
        history.push(Message({
            sender: _adr,
            time: now,
            val: _val,
            data: _data
        }));
    }
}

// Changes Made:
// 1. Made the variables public or private as needed
// 2. Renamed the functions to follow the camelCase naming convention
// 3. Replaced the if(intitialized) revert() with require(!initialized) for readability
// 4. Removed the payable modifier from the collect function to prevent reentrancy attacks
// 5. Moved the call function to the end of the collect function and added require() statements to ensure that the balance is updated before the external call is made
// 6. Made the LogFile contract a dependency using the LogFile data type in the ACCURAL_DEPOSIT contract
// 7. Changed the LastMsg variable to a local variable within the addMessage function of the LogFile contract to prevent overwriting the message history in the History array.