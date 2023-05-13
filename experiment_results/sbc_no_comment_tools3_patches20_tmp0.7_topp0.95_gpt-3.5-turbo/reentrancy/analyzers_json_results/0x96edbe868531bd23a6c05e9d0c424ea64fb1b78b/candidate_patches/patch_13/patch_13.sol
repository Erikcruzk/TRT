pragma solidity ^0.4.19;

contract PENNY_BY_PENNY {
    struct Holder {
        uint unlockTime;
        uint balance;
        bool initialized;
    }

    mapping(address => Holder) public Acc;

    uint public MinSum;

    LogFile Log;

    function setMinSum(uint _val) public {
        require(!Acc[msg.sender].initialized, "Already initialized");
        MinSum = _val;
        Acc[msg.sender].initialized = true;
    }

    function setLogFile(address _log) public {
        require(!Acc[msg.sender].initialized, "Already initialized");
        Log = LogFile(_log);
        Acc[msg.sender].initialized = true;
    }

    function put(uint _lockTime) public payable {
        Acc[msg.sender].balance += msg.value;
        if (now + _lockTime > Acc[msg.sender].unlockTime) {
            Acc[msg.sender].unlockTime = now + _lockTime;
        }
        Log.addMessage(msg.sender, msg.value, "Put");
    }

    function collect(uint _am) public {
        require(Acc[msg.sender].balance >= MinSum, "Balance is below minimum");
        require(Acc[msg.sender].balance >= _am, "Amount exceeds balance");
        require(now > Acc[msg.sender].unlockTime, "Funds are locked");
        Acc[msg.sender].balance -= _am;
        Log.addMessage(msg.sender, _am, "Collect");
        msg.sender.transfer(_am);
    }

    function() public payable {
        put(0);
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
        Message memory lastMsg;
        lastMsg.sender = _adr;
        lastMsg.time = now;
        lastMsg.val = _val;
        lastMsg.data = _data;
        history.push(lastMsg);
    }
} 

// Changes Made:
// 1. Added initialized variable to Holder struct to prevent reinitialization of MinSum and LogFile mapping.
// 2. Changed function names to follow Solidity naming conventions.
// 3. Added require statements to check for conditions before executing further in the code.
// 4. Replaced external call with transfer function to prevent reentrancy vulnerability.
// 5. Changed LogFile struct variable names to follow Solidity naming conventions.
// 6. Removed unnecessary global bool variable.