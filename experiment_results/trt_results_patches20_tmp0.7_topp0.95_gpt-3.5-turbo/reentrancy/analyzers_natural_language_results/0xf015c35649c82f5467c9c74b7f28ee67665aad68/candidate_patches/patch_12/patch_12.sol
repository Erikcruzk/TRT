pragma solidity ^0.4.25;

contract MY_BANK {
    mapping(address => Holder) public Acc;
    uint public MinSum = 1 ether;

    Log LogFile;

    struct Holder {
        uint unlockTime;
        uint balance;
        bool isLocked;
    }

    function MY_BANK(address log) public {
        LogFile = Log(log);
    }

    function Put(uint _unlockTime) public payable {
        Acc[msg.sender].balance += msg.value;
        if (_unlockTime > now) {
            Acc[msg.sender].unlockTime = _unlockTime;
            Acc[msg.sender].isLocked = true;
        }
        LogFile.AddMessage(msg.sender, msg.value, "Put");
    }

    function Collect(uint _am) public {
        var acc = Acc[msg.sender];
        require(acc.balance >= MinSum && acc.balance >= _am);
        require(!acc.isLocked && now > acc.unlockTime);
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
        Message memory lastMsg;
        lastMsg.Sender = _adr;
        lastMsg.Time = now;
        lastMsg.Val = _val;
        lastMsg.Data = _data;
        History.push(lastMsg);
    }
} 

// Changes Made:
// - Added a boolean flag to Holder struct to check if the account is locked or not
// - Removed payable modifier from Collect function as it does not require any ether transfer
// - Used require statements to check conditions instead of if statements to prevent reentrancy attacks
// - Added transfer statement to transfer ether to the user after deducting from the balance in Collect function
// - Initialized Message struct in AddMessage function to prevent overwriting previous messages