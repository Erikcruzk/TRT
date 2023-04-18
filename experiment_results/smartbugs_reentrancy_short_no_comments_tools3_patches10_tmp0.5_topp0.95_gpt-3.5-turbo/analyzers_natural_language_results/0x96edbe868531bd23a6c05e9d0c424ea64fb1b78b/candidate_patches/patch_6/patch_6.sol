pragma solidity ^0.8.0;

contract PENNY_BY_PENNY {
    struct Holder {
        uint256 unlockTime;
        uint256 balance;
    }

    mapping(address => Holder) public Acc;

    uint256 public MinSum;

    LogFile Log;

    bool initialized;

    function setMinSum(uint256 _val) public {
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

    function put(uint256 _lockTime) public payable {
        Holder storage acc = Acc[msg.sender];
        acc.balance += msg.value;
        if (block.timestamp + _lockTime > acc.unlockTime)
            acc.unlockTime = block.timestamp + _lockTime;
        Log.addMessage(msg.sender, msg.value, "Put");
    }

    function collect(uint256 _am) public {
        Holder storage acc = Acc[msg.sender];
        require(
            acc.balance >= MinSum && acc.balance >= _am && block.timestamp > acc.unlockTime,
            "Insufficient balance or time lock not expired"
        );
        acc.balance -= _am;
        (bool success, ) = msg.sender.call{value: _am}("");
        require(success, "Transfer failed");
        Log.addMessage(msg.sender, _am, "Collect");
    }

    receive() external payable {
        put(0);
    }
}

contract LogFile {
    struct Message {
        address Sender;
        string Data;
        uint256 Val;
        uint256 Time;
    }

    Message[] public History;

    function addMessage(address _adr, uint256 _val, string memory _data) public {
        Message memory lastMsg = Message({
            Sender: _adr,
            Time: block.timestamp,
            Val: _val,
            Data: _data
        });
        History.push(lastMsg);
    }
} 

// Changes Made:
// 1. Updated the Solidity version to ^0.8.0
// 2. Changed the function names to follow the Solidity naming convention
// 3. Replaced the "throw" keyword with "require"
// 4. Added "storage" keyword to the "acc" variable in the "put" and "collect" functions
// 5. Added "require" statements to ensure the necessary conditions are met before collecting funds
// 6. Moved the balance subtraction before the external call to prevent reentrancy vulnerability
// 7. Added a "receive" function to allow the contract to receive Ether.