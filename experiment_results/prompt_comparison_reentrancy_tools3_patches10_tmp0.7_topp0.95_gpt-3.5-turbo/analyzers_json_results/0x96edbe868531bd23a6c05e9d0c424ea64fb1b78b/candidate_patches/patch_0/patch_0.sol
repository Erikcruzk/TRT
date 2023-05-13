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

    modifier onlyInitialized {
        require(Acc[msg.sender].initialized);
        _;
    }

    function SetMinSum(uint _val) public {
        require(!Acc[msg.sender].initialized);
        MinSum = _val;
    }

    function SetLogFile(address _log) public {
        require(!Acc[msg.sender].initialized);
        Log = LogFile(_log);
    }

    function Initialized() public {
        Acc[msg.sender].initialized = true;
    }

    function Put(uint _lockTime) public payable onlyInitialized {
        var acc = Acc[msg.sender];
        acc.balance += msg.value;
        if (now + _lockTime > acc.unlockTime) acc.unlockTime = now + _lockTime;
        Log.AddMessage(msg.sender, msg.value, "Put");
    }

    function Collect(uint _am) public onlyInitialized {
        var acc = Acc[msg.sender];
        require(acc.balance >= MinSum && acc.balance >= _am && now > acc.unlockTime);
        acc.balance -= _am;
        Log.AddMessage(msg.sender, _am, "Collect");
        msg.sender.transfer(_am);
    }

    function() public payable {
        Put(0);
    }
}

contract LogFile {
    struct Message {
        address Sender;
        string Data;
        uint Val;
        uint Time;
    }

    Message[] public History;

    function AddMessage(address _adr, uint _val, string _data) public {
        Message memory lastMsg = Message({
            Sender: _adr,
            Time: now,
            Val: _val,
            Data: _data
        });
        History.push(lastMsg);
    }
} 

// Changes Made:
// 1. Added a bool "initialized" in the Holder struct to check if a user has been initialized.
// 2. Replaced the "throw" statement with the "require" statement.
// 3. Replaced the "call" method with the "transfer" method to avoid reentrancy attacks.
// 4. Added a modifier "onlyInitialized" to restrict access to functions that require initialization.
// 5. Removed the "LastMsg" state variable in the LogFile contract and replaced it with a local variable.