pragma solidity ^0.4.19;

contract MONEY_BOX {
    struct Holder {
        uint unlockTime;
        uint balance;
        bool isHolder;
    }

    mapping(address => Holder) public Acc;

    uint public MinSum;

    Log LogFile;

    bool initialized;

    function setMinSum(uint _val) public {
        require(!initialized);
        MinSum = _val;
    }

    function setLogFile(address _log) public {
        require(!initialized);
        LogFile = Log(_log);
    }

    function initialize() public {
        initialized = true;
    }

    function put(uint _lockTime) public payable {
        Holder storage acc = Acc[msg.sender];
        acc.balance += msg.value;
        if (now + _lockTime > acc.unlockTime) acc.unlockTime = now + _lockTime;
        if (!acc.isHolder) {
            acc.isHolder = true;
        }
        LogFile.addMessage(msg.sender, msg.value, "Put");
    }

    function collect(uint _am) public {
        Holder storage acc = Acc[msg.sender];
        require(acc.isHolder && acc.balance >= MinSum && acc.balance >= _am && now > acc.unlockTime);
        acc.balance -= _am;
        msg.sender.transfer(_am);
        LogFile.addMessage(msg.sender, _am, "Collect");
    }

    function() public payable {
        put(0);
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

    function addMessage(address _adr, uint _val, string _data) public {
        Message memory newMessage = Message({
            Sender: _adr,
            Val: _val,
            Data: _data,
            Time: now
        });
        History.push(newMessage);
    }
} 

/*
- Added isHolder flag to Holder struct to keep track of whether an account is a holder or not
- Changed function names to follow Solidity naming conventions
- Replaced throw statements with require statements
- Removed unnecessary payable modifier from collect function
- Replaced call.value with transfer function in collect function to prevent reentrancy vulnerability
- Changed LogFile.AddMessage calls to LogFile.addMessage to follow Solidity naming conventions
- Added memory keyword when creating newMessage in addMessage function to prevent stack too deep error
- Removed unused LastMsg variable from Log contract
*/