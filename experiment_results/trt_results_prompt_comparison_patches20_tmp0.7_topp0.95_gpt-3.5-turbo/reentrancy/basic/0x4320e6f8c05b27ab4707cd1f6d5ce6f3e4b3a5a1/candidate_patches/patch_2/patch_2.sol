pragma solidity ^0.4.19;

contract ACCURAL_DEPOSIT {
    mapping(address => uint256) public balances;

    uint public MinSum = 1 ether;

    LogFile Log;

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
        balances[msg.sender] -= _am;
        require(msg.sender.send(_am));
        Log.addMessage(msg.sender, _am, "Collect");
    }

    function initialize() public {
        require(!initialized);
        initialized = true;
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

// Changes Made:
// 1. Added constructor to initialize LogFile contract.
// 2. Changed function names to follow camelCase naming convention.
// 3. Replaced 'intitalized' with 'initialized' for spelling correction.
// 4. Replaced 'if (intitalized) revert();' with 'require(!initialized);'.
// 5. Added 'require(initialized);' in collect() function to ensure contract is initialized.
// 6. Moved 'balances[msg.sender] -= _am;' before 'msg.sender.send(_am);' in collect() function to avoid re-entrancy attack.
// 7. Changed struct variable names to follow camelCase naming convention.
// 8. Added 'memory' keyword in addMessage() function to explicitly specify memory allocation for newMessage variable.