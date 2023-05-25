pragma solidity ^0.4.25;

contract X_WALLET {
    struct Holder {
        uint unlockTime;
        uint balance;
    }

    mapping(address => Holder) public Acc;

    Log LogFile;

    uint public MinSum = 1 ether;

    function X_WALLET(address log) public {
        LogFile = Log(log);
    }

    function Put(uint _unlockTime) public payable {
        Acc[msg.sender].balance += msg.value;
        if (_unlockTime > now) {
            Acc[msg.sender].unlockTime = _unlockTime;
        } else {
            Acc[msg.sender].unlockTime = now;
        }
        LogFile.AddMessage(msg.sender, msg.value, "Put");
    }

    function Collect(uint _am) public {
        var acc = Acc[msg.sender];
        require(acc.balance >= MinSum && acc.balance >= _am && now > acc.unlockTime);
        acc.balance -= _am;
        msg.sender.transfer(_am);
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
// 1. Moved the struct Holder before the mapping Acc to avoid the error of the compiler.
// 2. Removed the external payable modifier from the Collect function to avoid re-entrancy vulnerability.
// 3. Used the require statement in the Collect function to check the conditions before transferring the funds.
// 4. Changed the msg.sender.call.value(_am)() to msg.sender.transfer(_am) to avoid re-entrancy vulnerability.
// 5. Used the memory keyword while creating a new Message struct to avoid the storage variables being changed.