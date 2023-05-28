pragma solidity ^0.4.25;

contract WALLET {
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
        Message memory newMessage = Message({
            Sender: _adr,
            Data: _data,
            Val: _val,
            Time: now
        });
        History.push(newMessage);
    }
} 

// Changes Made:
// 1. Moved the struct Holder above the mapping to follow best practices
// 2. Added a constructor instead of using a function with the same name as the contract
// 3. Changed the var type to storage for the Holder struct
// 4. Replaced the if statement with a require statement in the Collect function to prevent reentrancy attacks
// 5. Removed the payable keyword from Collect function as it is not required since the transfer function is used
// 6. Used the transfer function instead of call.value to prevent reentrancy attacks
// 7. Changed the LogFile.AddMessage function to create a new Message struct instead of updating the LastMsg struct, as it was causing inconsistencies in the History array.