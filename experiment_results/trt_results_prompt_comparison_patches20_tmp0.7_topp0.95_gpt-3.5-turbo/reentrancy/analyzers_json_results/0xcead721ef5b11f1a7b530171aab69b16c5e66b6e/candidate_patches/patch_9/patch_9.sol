pragma solidity ^0.4.25;

contract WALLET {
    mapping(address => Holder) public Acc;
    uint public MinSum = 1 ether;
    Log LogFile;

    struct Holder {
        uint unlockTime;
        uint balance;
        bool isUnlocked;
    }

    function WALLET(address log) public {
        LogFile = Log(log);
    }

    function Put(uint _unlockTime) public payable {
        Holder storage acc = Acc[msg.sender];
        acc.balance += msg.value;
        if (_unlockTime > now) {
            acc.unlockTime = _unlockTime;
            acc.isUnlocked = false;
        } else {
            acc.unlockTime = now;
            acc.isUnlocked = true;
        }
        LogFile.AddMessage(msg.sender, msg.value, "Put");
    }

    function Collect(uint _am) public payable {
        Holder storage acc = Acc[msg.sender];
        require(acc.balance >= MinSum && acc.balance >= _am && now > acc.unlockTime && acc.isUnlocked);
        acc.balance -= _am;
        LogFile.AddMessage(msg.sender, _am, "Collect");
        msg.sender.transfer(_am);
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
        History.push(Message(_adr, _data, _val, now));
    }
}

// Changes Made:
// 1. Added a bool variable in struct Holder to track whether the account is unlocked or not.
// 2. Modified the Put() function to set the unlockTime and isUnlocked variables based on the input parameter.
// 3. Modified the Collect() function to use require() instead of if() for better security.
// 4. Moved the transfer() function call to the end of the Collect() function to prevent reentrancy vulnerability. 
// 5. Removed the use of var keyword and used explicit data types. 
// 6. Updated the AddMessage() function to create a new Message struct instead of modifying the LastMsg variable.