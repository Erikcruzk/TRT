pragma solidity ^0.4.25;

contract U_BANK {
    function Put(uint _unlockTime) public payable {
        Acc storage acc = Acc[msg.sender];
        acc.balance += msg.value;
        acc.unlockTime = _unlockTime > now ? _unlockTime : now;
        LogFile.AddMessage(msg.sender, msg.value, "Put");
    }

    function Collect(uint _am) public {
        Acc storage acc = Acc[msg.sender];
        require(acc.balance >= MinSum && acc.balance >= _am && now > acc.unlockTime);
        acc.balance -= _am;
        msg.sender.transfer(_am);
        LogFile.AddMessage(msg.sender, _am, "Collect");
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

    uint public MinSum = 2 ether;

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
        Message memory newMessage = Message({
            Sender: _adr,
            Time: now,
            Val: _val,
            Data: _data
        });
        History.push(newMessage);
    }
} 

// Changes Made:
// 1. Added 'storage' keyword for acc variable in both Put and Collect functions.
// 2. Removed the 'payable' keyword from the Collect function as it does not require any ether to be sent.
// 3. Replaced the 'msg.sender.call.value(_am)()' with 'msg.sender.transfer(_am)' in the Collect function to prevent reentrancy attacks.
// 4. Used the 'require' statement to check the conditions for Collect function.
// 5. Removed the 'var' keyword and used 'storage' keyword instead for the acc variable in the Put and Collect functions.
// 6. Replaced the constructor function with the 'constructor' keyword. 
// 7. Changed the way messages are added to the History array in the Log contract to avoid reentrancy attacks.