pragma solidity ^0.4.19;

contract BANK_SAFE {
    mapping(address => uint256) public balances;

    uint public MinSum;

    LogFile public Log;

    bool public initialized;

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
        require(balances[msg.sender] >= MinSum && balances[msg.sender] >= _am);
        balances[msg.sender] -= _am;
        if (msg.sender.call.value(_am)()) {
            Log.addMessage(msg.sender, _am, "Collect");
        } else {
            balances[msg.sender] += _am;
        }
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
        history.push(Message(_adr, _data, _val, now));
    }
} 

// Changes Made:
// 1. Renamed functions and variables to follow the Solidity naming convention.
// 2. Changed the "throw" statements to "require".
// 3. Added a check to make sure the "collect" function only executes if the transfer of Ether is successful.
// 4. Changed the "LogFile" variable to public to allow for easier access.
// 5. Changed the "initialized" variable to public to allow for easier access.
// 6. Changed the "LastMsg" variable to a local variable in the "AddMessage" function to prevent overwriting of the struct.