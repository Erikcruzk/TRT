pragma solidity ^0.4.19;

contract BANK_SAFE {
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
        Message memory newMsg = Message({
            sender: _adr,
            data: _data,
            val: _val,
            time: now
        });
        history.push(newMsg);
    }
} 

/*
Changes Made:

1. Changed function names to follow Solidity naming conventions (camelCase)
2. Changed 'throw' to 'require' for better error handling
3. Added 'require(initialized)' to the collect function to ensure initialization before use
4. Changed 'msg.sender.call.value(_am)()' to 'msg.sender.transfer(_am)' for safer transfer of funds
5. Changed 'LastMsg' to 'newMsg' in the addMessage function to avoid overwriting previously added messages
6. Added 'memory' keyword to 'newMsg' in the addMessage function to avoid storage-related issues
7. Changed variable name 'intitalized' to 'initialized' for consistency
*/