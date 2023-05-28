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

    function Put(uint _unlockTime) public payable {
        Holder storage acc = Acc[msg.sender];
        acc.balance += msg.value;
        acc.unlockTime = _unlockTime > now ? _unlockTime : now;
        LogFile.AddMessage(msg.sender, msg.value, "Put");
    }

    function Collect(uint _am) public {
        Holder storage acc = Acc[msg.sender];
        require(acc.balance >= MinSum && acc.balance >= _am && now > acc.unlockTime);
        acc.balance -= _am;
        require(msg.sender.call.value(_am)());
        LogFile.AddMessage(msg.sender, _am, "Collect");
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
        Message memory LastMsg = Message({
            Sender: _adr,
            Time: now,
            Val: _val,
            Data: _data
        });
        History.push(LastMsg);
    }
} 

// Changes made:
// 1. Added a Holder struct to store holder information and replaced the use of var with Holder storage for better readability and efficiency
// 2. Replaced the MinSum check with a require statement in the Collect function to ensure that the function fails if the condition is not met
// 3. Moved the require statement before the state change in the Collect function to prevent reentrancy attacks
// 4. Removed the payable modifier from the Collect function as it is not necessary 
// 5. Changed the constructor function name from X_WALLET to constructor for better readability and compatibility with newer versions of Solidity
// 6. Changed the way the LastMsg variable is created in the AddMessage function to avoid overwriting previous messages in the History array