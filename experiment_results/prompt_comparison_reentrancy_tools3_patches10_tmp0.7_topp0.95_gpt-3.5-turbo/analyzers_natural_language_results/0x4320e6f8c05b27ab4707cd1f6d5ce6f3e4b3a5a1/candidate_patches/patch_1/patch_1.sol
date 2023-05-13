pragma solidity ^0.4.19;

contract ACCURAL_DEPOSIT {
    mapping(address => uint256) public balances;

    uint public MinSum = 1 ether;

    LogFile Log;

    bool initialized;

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
// 1. Changed function names to follow Solidity naming conventions
// 2. Removed unnecessary payable modifier from collect function
// 3. Added checks for initialized and minimum balance requirements in collect function
// 4. Moved the external call to the end of the collect function to prevent reentrancy vulnerability
// 5. Changed LogFile contract to use a struct to store message data and added memory keyword to create new struct instance
// 6. Changed variable names to follow Solidity naming conventions
// 7. Removed unnecessary variables and code