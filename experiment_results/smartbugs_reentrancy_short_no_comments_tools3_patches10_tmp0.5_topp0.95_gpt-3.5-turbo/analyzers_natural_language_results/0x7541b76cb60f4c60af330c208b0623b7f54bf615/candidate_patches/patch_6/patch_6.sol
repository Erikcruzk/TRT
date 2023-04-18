pragma solidity ^0.4.25;

contract U_BANK {
    struct Holder {
        uint unlockTime;
        uint balance;
    }

    mapping (address => Holder) public Acc;

    Log LogFile;

    uint public MinSum = 2 ether;

    constructor(address log) public {
        LogFile = Log(log);
    }

    function Put(uint _unlockTime) public payable {
        require(msg.value > 0, "Amount must be greater than 0");
        Holder storage acc = Acc[msg.sender];
        acc.balance += msg.value;
        acc.unlockTime = _unlockTime > now ? _unlockTime : now;
        LogFile.AddMessage(msg.sender, msg.value, "Put");
    }

    function Collect(uint _am) public payable {
        Holder storage acc = Acc[msg.sender];
        require(acc.balance >= MinSum, "Account balance is less than minimum sum");
        require(acc.balance >= _am, "Account balance is less than requested amount");
        require(now > acc.unlockTime, "Account is locked");
        acc.balance -= _am;
        if (msg.sender.call.value(_am)()) {
            LogFile.AddMessage(msg.sender, _am, "Collect");
        } else {
            acc.balance += _am;
            revert("Transaction failed");
        }
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
            Time: now,
            Val: _val,
            Data: _data
        });
        History.push(newMessage);
    }
} 

// Changes Made:
// 1. Added require statements to check preconditions before executing the Collect function.
// 2. Moved the struct Holder to the beginning of the contract for better readability.
// 3. Changed the LogFile.AddMessage function call to be after the state variable has been updated to prevent reentrancy attack.
// 4. Added a new constructor function to initialize the LogFile contract.
// 5. Changed the LogFile.AddMessage function to create a new Message struct instead of updating the LastMsg struct to prevent overwriting of previous messages.