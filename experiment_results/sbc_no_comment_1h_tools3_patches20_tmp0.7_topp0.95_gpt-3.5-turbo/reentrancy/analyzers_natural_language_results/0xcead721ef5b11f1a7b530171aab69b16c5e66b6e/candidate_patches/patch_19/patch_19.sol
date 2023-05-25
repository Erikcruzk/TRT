pragma solidity ^0.4.25;

contract WALLET {
    mapping(address => Holder) public Acc;
    uint public MinSum = 1 ether;
    Log LogFile;

    struct Holder {
        uint unlockTime;
        uint balance;
    }

    function WALLET(address log) public {
        LogFile = Log(log);
    }

    function Put(uint _unlockTime) public payable {
        Acc[msg.sender].balance += msg.value;
        Acc[msg.sender].unlockTime = _unlockTime > now ? _unlockTime : now;
        LogFile.AddMessage(msg.sender, msg.value, "Put");
    }

    function Collect(uint _am) public {
        require(
            Acc[msg.sender].balance >= MinSum && Acc[msg.sender].balance >= _am && now > Acc[msg.sender].unlockTime,
            "Insufficient balance or locked funds"
        );
        Acc[msg.sender].balance -= _am;
        LogFile.AddMessage(msg.sender, _am, "Collect");
        require(msg.sender.call.value(_am)(), "Transfer failed");
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
        Message memory lastMsg;
        lastMsg.Sender = _adr;
        lastMsg.Time = now;
        lastMsg.Val = _val;
        lastMsg.Data = _data;
        History.push(lastMsg);
    }
} 

// Changes Made:
// 1. Removed the "payable" keyword from the Collect function as it is unnecessary.
// 2. Added a require statement to check for sufficient balance and unlocked funds in the Collect function.
// 3. Moved the state variables in WALLET contract above the functions as per best practices.
// 4. Added a memory keyword to the Message variable in the AddMessage function to avoid read of persistent state following external call vulnerability.
// 5. Removed the reentrancy vulnerability by calling the external contract function after all state modifications are completed and adding a transfer failed check.