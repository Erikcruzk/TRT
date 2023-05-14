pragma solidity ^0.4.25;

contract U_BANK {
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
        require(msg.sender.call.value(_am)());
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
        Message memory LastMsg;
        LastMsg.Sender = _adr;
        LastMsg.Time = now;
        LastMsg.Val = _val;
        LastMsg.Data = _data;
        History.push(LastMsg);
    }
} 

// Changes Made:
// 1. Moved the struct Holder definition and the mapping inside the contract and declared it as a storage variable to be able to modify its values inside functions
// 2. Changed the function U_BANK to constructor as it is better practice
// 3. Removed the payable modifier from the Collect function as there is no need to send any ether to it
// 4. Added require statements to ensure that the conditions for withdrawing money are met before making the transfer
// 5. Removed the var keyword and replaced it with the explicit type declaration
// 6. Added memory keyword to the definition of the LastMsg struct inside the AddMessage function to avoid storage allocation
// 7. Initialized LastMsg struct inside the AddMessage function to avoid possible memory leaks or reusing the same struct multiple times.