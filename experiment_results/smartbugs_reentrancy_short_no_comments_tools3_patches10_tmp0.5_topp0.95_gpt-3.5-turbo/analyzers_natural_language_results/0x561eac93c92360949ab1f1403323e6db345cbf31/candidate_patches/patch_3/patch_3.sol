pragma solidity ^0.8.0;

contract BANK_SAFE {
    mapping (address => uint256) public balances;   
   
    uint public MinSum;
    
    LogFile Log;
    
    bool initialized;
    
    function setMinSum(uint256 _val) public {
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
    
    function collect(uint256 _am) public {
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
        uint256 val;
        uint256 time;
    }
    
    Message[] public history;
    
    function addMessage(address _adr, uint256 _val, string memory _data) public {
        Message memory message = Message({
            sender: _adr,
            time: block.timestamp,
            val: _val,
            data: _data
        });
        history.push(message);
    }
}

// Changes Made:
// 1. Updated the pragma version to 0.8.0
// 2. Changed function names to follow the Solidity style guide
// 3. Added require statements to check conditions and prevent errors
// 4. Moved the balance check above the external call in the collect function to prevent reentrancy attacks
// 5. Added a receive function to handle incoming ether transactions
// 6. Changed the LogFile struct to use memory instead of storage to save gas costs