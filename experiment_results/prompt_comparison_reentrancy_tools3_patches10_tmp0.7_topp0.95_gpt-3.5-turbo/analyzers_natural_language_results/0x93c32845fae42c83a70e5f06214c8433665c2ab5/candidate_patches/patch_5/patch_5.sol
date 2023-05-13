pragma solidity ^0.4.25;

contract X_WALLET {
    struct Holder {
        uint unlockTime;
        uint balance;
    }

    mapping(address => Holder) public Acc;

    Log LogFile;

    uint public MinSum = 1 ether;

    constructor(address log) public {
        LogFile = Log(log);
    }

    function put(uint _unlockTime) public payable {
        Acc[msg.sender].balance += msg.value;
        Acc[msg.sender].unlockTime = _unlockTime > now ? _unlockTime : now;
        LogFile.addMessage(msg.sender, msg.value, "Put");
    }

    function collect(uint _am) public {
        Holder storage acc = Acc[msg.sender];
        require(acc.balance >= MinSum && acc.balance >= _am && now > acc.unlockTime);
        acc.balance -= _am;
        require(msg.sender.call.value(_am)());
        LogFile.addMessage(msg.sender, _am, "Collect");
    }

    function() public payable {
        put(0);
    }
}

contract Log {
    struct Message {
        address sender;
        string data;
        uint val;
        uint time;
    }

    Message[] public history;

    function addMessage(address _adr, uint _val, string _data) public {
        Message memory newMessage = Message(_adr, _data, _val, now);
        history.push(newMessage);
    }
} 

// Changes Made:
// 1. Changed the function names to start with a lowercase letter to follow the naming convention.
// 2. Moved the struct and mapping definitions to the top.
// 3. Added a constructor for initializing the Log contract.
// 4. Replaced var with the explicit type Holder.
// 5. Added require statements to ensure that the conditions are met before execution.
// 6. Used storage keyword to modify the state variable in collect function.
// 7. Changed the LogFile variable to LogFile.addMessage() in put and collect functions to match the function name. 
// 8. Changed the variable names to follow the naming convention.
// 9. Added a memory variable to store the new message in the Log contract.