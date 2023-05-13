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

    function setLogFile(address _log) public {
        require(!initialized);
        Log = LogFile(_log);
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
        msg.sender.transfer(_am);
        Log.addMessage(msg.sender, _am, "Collect");
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
// 1. Changed function names to use camelCase and start with lowercase letters to follow Solidity naming conventions.
// 2. Replaced "revert()" with "require()" for better readability.
// 3. Removed unnecessary "payable" keyword from "collect()" function.
// 4. Reordered "collect()" function to first update the state variables before sending ether to the caller.
// 5. Added "memory" keyword when creating a new Message struct in "addMessage()" function for better gas optimization.