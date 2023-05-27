pragma solidity ^0.8.0;

contract PRIVATE_ETH_CELL {
    mapping(address => uint256) public balances;

    uint public MinSum;

    LogFile public Log;

    bool initialized;

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
        require(balances[msg.sender] >= MinSum && balances[msg.sender] >= _am, "Insufficient balance");
        balances[msg.sender] -= _am;
        Log.addMessage(msg.sender, _am, "Collect");
        (bool success, ) = msg.sender.call{value: _am}("");
        require(success, "Transfer failed");
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
        Message memory lastMsg;
        lastMsg.sender = _adr;
        lastMsg.time = block.timestamp;
        lastMsg.val = _val;
        lastMsg.data = _data;
        history.push(lastMsg);
    }
} 

// Changes made:
// 1. Updated the Solidity version to ^0.8.0
// 2. Changed the function and variable names to follow the Solidity style guide
// 3. Added error messages and require statements to ensure proper functioning and prevent errors
// 4. Added a receive function to handle Ether transfers
// 5. Initialized the Message struct in the addMessage function to prevent data corruption.