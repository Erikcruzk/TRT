pragma solidity ^0.8.0;

contract BANK_SAFE {
    mapping (address => uint256) public balances;
    uint public MinSum;
    LogFile Log;
    bool initialized;

    constructor() {
        initialized = false;
    }

    function setMinSum(uint _val) public {
        require(!initialized, "Contract already initialized");
        MinSum = _val;
    }

    function setLogFile(address _log) public {
        require(!initialized, "Contract already initialized");
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
        require(balances[msg.sender] >= MinSum && balances[msg.sender] >= _am, "Insufficient balance");
        balances[msg.sender] -= _am;
        Log.addMessage(msg.sender, _am, "Collect");
        (bool success, ) = msg.sender.call{value: _am}("");
        require(success, "Transfer failed");
    }

    function() external payable {
        deposit();
    }
}

contract LogFile {
    struct Message {
        address Sender;
        string  Data;
        uint Val;
        uint  Time;
    }
    
    Message[] public History;
    
    function addMessage(address _adr, uint _val, string memory _data) public {
        Message memory lastMsg;
        lastMsg.Sender = _adr;
        lastMsg.Time = block.timestamp;
        lastMsg.Val = _val;
        lastMsg.Data = _data;
        History.push(lastMsg);
    }
}

// The repaired contract addresses the following issues:
// - Updated Solidity version to ^0.8.0
// - Added constructor to initialize initialized variable to false
// - Replaced intitalized with initialized and added require statements to prevent functions from being called after initialization
// - Added require statement to collect function to check if the balance is sufficient before deducting from it
// - Moved balance deduction and Log message addition before the external call to prevent reentrancy vulnerability
// - Changed LogFile's addMessage function to create a new Message struct instead of modifying the LastMsg variable, and changed Time to use block.timestamp instead of now
// - Removed unused variable LastMsg
// - Added error messages to require and revert statements for better debugging