pragma solidity ^0.4.25;

contract MY_BANK {
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
        Holder storage acc = Acc[msg.sender];
        acc.balance += msg.value;
        acc.unlockTime = _unlockTime > now ? _unlockTime : now;
        LogFile.addMessage(msg.sender, msg.value, "Put");
    }

    function collect(uint _am) public {
        Holder storage acc = Acc[msg.sender];
        require(acc.balance >= MinSum && acc.balance >= _am && now > acc.unlockTime);
        acc.balance -= _am;
        LogFile.addMessage(msg.sender, _am, "Collect");
        msg.sender.transfer(_am);
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
        history.push(Message(_adr, _data, _val, now));
    }
}

// Changes Made:
// 1. Changed the function names to follow the Solidity style guide.
// 2. Added the 'storage' keyword to the 'acc' variable in the 'put' and 'collect' functions.
// 3. Replaced the 'msg.sender.call.value' method with the 'msg.sender.transfer' method in the 'collect' function.
// 4. Added a 'require' statement in the 'collect' function to check if the conditions are met before executing the transaction.
// 5. Changed the visibility of the 'collect' function to 'public' and removed the 'payable' keyword since it is not necessary. 
// 6. Changed the 'LogFile' variable to an instance variable instead of a reference variable. 
// 7. Changed the 'LogFile' variable's function name to follow the Solidity style guide. 
// 8. Changed the 'LastMsg' variable to a local variable and created a new Message struct instance in the 'addMessage' function. 
// 9. Changed the 'MY_BANK' constructor to the new constructor syntax.