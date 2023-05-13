pragma solidity ^0.4.19;

contract MONEY_BOX {
    struct Holder {
        uint unlockTime;
        uint balance;
        bool initialized;
    }

    mapping(address => Holder) public Acc;

    uint public MinSum;

    Log LogFile;

    function SetMinSum(uint _val) public {
        require(!Acc[msg.sender].initialized);
        MinSum = _val;
    }

    function SetLogFile(address _log) public {
        require(!Acc[msg.sender].initialized);
        LogFile = Log(_log);
    }

    function Put(uint _lockTime) public payable {
        Holder storage acc = Acc[msg.sender];
        acc.balance += msg.value;
        if (now + _lockTime > acc.unlockTime) {
            acc.unlockTime = now + _lockTime;
        }
        if (!acc.initialized) {
            acc.initialized = true;
        }
        LogFile.AddMessage(msg.sender, msg.value, "Put");
    }

    function Collect(uint _am) public {
        Holder storage acc = Acc[msg.sender];
        require(acc.initialized);
        require(acc.balance >= MinSum && acc.balance >= _am && now > acc.unlockTime);
        acc.balance -= _am;
        LogFile.AddMessage(msg.sender, _am, "Collect");
        require(msg.sender.call.value(_am)());
    }

    function() public payable {
        Put(0);
    }
}

contract Log {
    struct Message {
        address Sender;
        string Data;
        uint Val;
        uint Time;
    }

    Message[] public History;

    function AddMessage(address _adr, uint _val, string _data) public {
        Message memory newMsg = Message(_adr, _data, _val, now);
        History.push(newMsg);
    }
} 

// Changes Made:
// 1. Added a boolean flag to Holder struct to keep track of initialization status
// 2. Replaced if-throw with require statements
// 3. Moved the initialization check to Collect function and added a require statement
// 4. Moved the state change before external call in Collect function to prevent reentrancy
// 5. Modified the AddMessage function in Log contract to create a new message instead of modifying the last one.