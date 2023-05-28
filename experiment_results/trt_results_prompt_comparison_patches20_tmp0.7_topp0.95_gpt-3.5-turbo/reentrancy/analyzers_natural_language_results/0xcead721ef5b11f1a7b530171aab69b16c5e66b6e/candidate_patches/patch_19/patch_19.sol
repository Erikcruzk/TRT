pragma solidity ^0.4.25;

contract WALLET {
    function Put(uint _unlockTime) public payable {
        Holder storage acc = Acc[msg.sender];
        acc.balance += msg.value;
        acc.unlockTime = _unlockTime > now ? _unlockTime : now;
        LogFile.AddMessage(msg.sender, msg.value, "Put");
    }

    function Collect(uint _am) public {
        Holder storage acc = Acc[msg.sender];
        if (acc.balance >= MinSum && acc.balance >= _am && now > acc.unlockTime) {
            acc.balance -= _am;
            if (msg.sender.call.value(_am)()) {
                LogFile.AddMessage(msg.sender, _am, "Collect");
            } else {
                acc.balance += _am;
            }
        }
    }

    function() public payable {
        Put(0);
    }

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
        Message memory lastMsg = Message({
            Sender: _adr,
            Time: now,
            Val: _val,
            Data: _data
        });
        History.push(lastMsg);
    }
} 

// Changes made:
// - Added 'storage' to 'acc' variable in Put() and Collect() functions to access the state variable.
// - Removed 'payable' from Collect() function as it does not receive any ether.
// - Moved the deduction of balance above the external call in Collect() function to prevent reentrancy vulnerability.
// - Replaced 'if(msg.sender.call.value(_am)())' with an if-else statement to handle the case of unsuccessful external calls.
// - Changed the constructor name to 'constructor' as the previous constructor syntax is deprecated. 
// - Used 'memory' instead of 'storage' to create a new Message struct in AddMessage() function to save gas cost.