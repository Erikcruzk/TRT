pragma solidity ^0.4.25;

contract MY_BANK
{
    struct Holder   
    {
        uint unlockTime;
        uint balance;
    }

    mapping (address => Holder) public Acc;
    Log LogFile;
    uint public MinSum = 1 ether;    

    constructor(address log) public{
        LogFile = Log(log);
    }

    function Put(uint _unlockTime) public payable {
        Acc[msg.sender].balance += msg.value;
        Acc[msg.sender].unlockTime = _unlockTime > now ? _unlockTime : now;
        LogFile.AddMessage(msg.sender, msg.value, "Put");
    }

    function Collect(uint _am) public payable {
        Holder storage acc = Acc[msg.sender];
        require(acc.balance >= MinSum && acc.balance >= _am && now > acc.unlockTime, "Insufficient balance or invalid unlock time");
        acc.balance -= _am;
        require(msg.sender.call.value(_am)(), "Transfer failed");
        LogFile.AddMessage(msg.sender, _am, "Collect");
    }

    function() public payable {
        Put(0);
    }
}

contract Log {
    struct Message {
        address Sender;
        string  Data;
        uint Val;
        uint  Time;
    }

    Message[] public History;

    function AddMessage(address _adr, uint _val, string _data) public {
        Message memory msg;
        msg.Sender = _adr;
        msg.Time = now;
        msg.Val = _val;
        msg.Data = _data;
        History.push(msg);
    }
} 

// The repaired contract fixes the reentrancy vulnerability by first updating the state variables before making an external call, and also adds require statements to ensure that the contract is being used properly. It also updates the constructor syntax and fixes some syntax issues.