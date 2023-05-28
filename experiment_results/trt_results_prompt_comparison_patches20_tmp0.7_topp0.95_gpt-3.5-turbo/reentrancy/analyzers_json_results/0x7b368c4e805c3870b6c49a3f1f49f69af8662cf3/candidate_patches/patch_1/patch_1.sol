pragma solidity ^0.4.25;

contract W_WALLET {
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
        Message memory newMsg = Message({
            Sender: _adr,
            Time: now,
            Val: _val,
            Data: _data
        });
        History.push(newMsg);
    }
} 

// Changes Made:
// 1. Added a constructor instead of a function with the same name as the contract.
// 2. Removed the payable keyword from the Collect function since it doesn't need to receive any ether.
// 3. Added a require statement to check the balance and unlock time before transferring ether.
// 4. Changed the var keyword to Holder storage to explicitly specify the storage location.
// 5. Changed the Acc[msg.sender] to Holder storage acc = Acc[msg.sender] to reduce gas costs.
// 6. Replaced the msg.sender.call.value(_am)() with msg.sender.transfer(_am) to prevent reentrancy attacks.
// 7. Changed the LogFile.AddMessage function to create a new Message struct instead of modifying the LastMsg struct.