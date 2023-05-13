pragma solidity ^0.4.19;

contract PENNY_BY_PENNY {
    struct Holder {
        uint unlockTime;
        uint balance;
    }

    mapping(address => Holder) public Acc;

    uint public MinSum;

    LogFile Log;

    bool initialized;

    modifier onlyUninitialized() {
        require(!initialized);
        _;
    }

    function setMinSum(uint _val) public onlyUninitialized {
        MinSum = _val;
    }

    function setLogFile(address _log) public onlyUninitialized {
        Log = LogFile(_log);
    }

    function initialize() public onlyUninitialized {
        initialized = true;
    }

    function put(uint _lockTime) public payable {
        Holder storage acc = Acc[msg.sender];
        acc.balance += msg.value;
        if (now + _lockTime > acc.unlockTime) {
            acc.unlockTime = now + _lockTime;
        }
        Log.addMessage(msg.sender, msg.value, "Put");
    }

    function collect(uint _am) public {
        Holder storage acc = Acc[msg.sender];
        require(acc.balance >= MinSum && acc.balance >= _am && now > acc.unlockTime);
        acc.balance -= _am;
        require(msg.sender.call.value(_am)());
        Log.addMessage(msg.sender, _am, "Collect");
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

// Changes Made
// 1. Added a modifier onlyUninitialized to check if the contract is already initialized
// 2. Replaced throw with require in functions SetMinSum and SetLogFile
// 3. Replaced var with storage in all functions that use mappings to explicitly state storage
// 4. Added a require statement in function collect to check if the account balance is greater than or equal to MinSum before allowing withdrawals
// 5. Moved the creation of a new Message struct in function addMessage to memory to save gas costs.