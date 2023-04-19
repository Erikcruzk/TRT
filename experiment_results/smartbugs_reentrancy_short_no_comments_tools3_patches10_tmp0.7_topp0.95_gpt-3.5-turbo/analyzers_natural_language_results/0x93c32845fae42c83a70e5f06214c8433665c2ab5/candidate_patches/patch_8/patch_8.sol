pragma solidity ^0.4.25;

contract X_WALLET
{
    struct Holder   
    {
        uint unlockTime;
        uint balance;
    }
    
    mapping (address => Holder) public Acc;
    
    Log LogFile;
    uint public MinSum = 1 ether;    
    
    function X_WALLET(address log) public{
        LogFile = Log(log);
    }
    
    function Put(uint _unlockTime) public payable {
        require(msg.value > 0, "Value must be greater than 0");
        Holder storage acc = Acc[msg.sender];
        acc.balance += msg.value;
        acc.unlockTime = _unlockTime > now ? _unlockTime : now;
        LogFile.AddMessage(msg.sender, msg.value, "Put");
    }
    
    function Collect(uint _am) public {
        Holder storage acc = Acc[msg.sender];
        require(acc.balance >= MinSum, "Balance must be greater than minimum sum");
        require(acc.balance >= _am, "Balance must be greater than amount");
        require(now > acc.unlockTime, "Unlock time has not been reached");
        acc.balance -= _am;
        require(msg.sender.call.value(_am)(), "Transfer failed");
        LogFile.AddMessage(msg.sender, _am, "Collect");
    }
    
    function() public payable {
        Put(0);
    }
}

contract Log 
{
    struct Message
    {
        address Sender;
        string Data;
        uint Val;
        uint Time;
    }
    
    Message[] public History;
    
    function AddMessage(address _adr, uint _val, string _data) public {
        Message memory newMsg = Message(_adr, _data, _val, now);
        History.push(newMsg);
    }
}