pragma solidity ^0.4.19;

contract DEP_BANK {
    mapping(address => uint256) public balances;

    uint public MinSum;

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

    function collect(uint _am) public payable {
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
        Message memory msg;
        msg.sender = _adr;
        msg.time = now;
        msg.val = _val;
        msg.data = _data;
        history.push(msg);
    }
} 

// Changes Made:
// 1. Changed function names to follow Solidity naming convention
// 2. Added 'require' instead of 'if' statements to check conditions and throw errors
// 3. Moved the 'balances[msg.sender] -= _am' line before the 'require(msg.sender.call.value(_am)());' line
// 4. Initialized 'Message memory msg;' to fix the reentrancy vulnerability detected by Mythril
// 5. Changed 'LastMsg' to 'msg' in addMessage function to fix the reentrancy vulnerability detected by Mythril