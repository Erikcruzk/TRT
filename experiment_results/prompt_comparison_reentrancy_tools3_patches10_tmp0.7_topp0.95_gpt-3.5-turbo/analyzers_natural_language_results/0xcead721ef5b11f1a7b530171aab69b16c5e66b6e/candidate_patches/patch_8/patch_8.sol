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
        if (
            acc.balance >= MinSum && acc.balance >= _am && now > acc.unlockTime
        ) {
            acc.balance -= _am;
            if (!msg.sender.send(_am)) {
                acc.balance += _am;
                return;
            }
            LogFile.AddMessage(msg.sender, _am, "Collect");
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
        Message memory LastMsg = Message({
            Sender: _adr,
            Time: now,
            Val: _val,
            Data: _data
        });
        History.push(LastMsg);
    }
} 

// The following are the changes made to the code:
// 1. In the Collect function, the reentrancy vulnerability was fixed by first reducing the balance of the account holder and then using send() to transfer the amount to the account holder. This ensures that the account holder's balance is updated before the transfer is made, preventing any possible reentrancy attacks.
// 2. In the Put function, the storage keyword was added to the acc variable declaration to ensure that any changes made to acc.balance and acc.unlockTime are persisted to storage.
// 3. In the constructor function, the constructor keyword was used instead of the contract name to define the constructor. 
// 4. In the AddMessage function of the Log contract, the LastMsg variable was changed to a memory variable to avoid overwriting previously stored messages when a new message is added to the History array.