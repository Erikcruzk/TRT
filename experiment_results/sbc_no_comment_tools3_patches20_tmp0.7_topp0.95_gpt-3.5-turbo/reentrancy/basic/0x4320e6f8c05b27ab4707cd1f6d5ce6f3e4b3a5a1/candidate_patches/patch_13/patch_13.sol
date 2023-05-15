pragma solidity ^0.4.19;

contract ACCURAL_DEPOSIT {
    mapping(address => uint256) public balances;

    uint public MinSum = 1 ether;

    LogFile public Log;

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
        require(msg.sender.call.value(_am)());
        balances[msg.sender] -= _am;
        Log.addMessage(msg.sender, _am, "Collect");
    }

    function initialize() public {
        require(!initialized);
        initialized = true;
    }

    function () public payable {
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
        Message memory msg;
        msg.sender = _adr;
        msg.time = now;
        msg.val = _val;
        msg.data = _data;
        history.push(msg);
    }
} 

// Changes Made:
// 1. Added constructor to initialize the LogFile contract
// 2. Changed function names to follow Solidity naming conventions (camelCase)
// 3. Added require statements for better error handling
// 4. Changed the 'initialized' variable to lowercase for consistency
// 5. Changed the 'Message' struct variable name to 'msg' to avoid conflicts with the function name 'msg.sender'
// 6. Added memory keyword to the 'Message' struct in the addMessage function for better optimization
// 7. Removed unnecessary payable keyword from the 'collect' function since it does not receive any ether.