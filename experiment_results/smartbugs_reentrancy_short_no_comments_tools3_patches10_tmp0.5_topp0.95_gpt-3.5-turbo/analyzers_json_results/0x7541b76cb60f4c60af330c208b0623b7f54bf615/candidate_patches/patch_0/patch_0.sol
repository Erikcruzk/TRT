pragma solidity ^0.4.25;

contract U_BANK
{
    struct Holder   
    {
        uint unlockTime;
        uint balance;
    }

    mapping (address => Holder) public Acc;

    Log LogFile;

    uint public MinSum = 2 ether;    

    function U_BANK(address log) public{
        LogFile = Log(log);
    }

    function Put(uint _unlockTime)
    public
    payable
    {
        Acc[msg.sender].balance += msg.value;
        Acc[msg.sender].unlockTime = _unlockTime > now ? _unlockTime : now;
        LogFile.AddMessage(msg.sender, msg.value, "Put");
    }

    function Collect(uint _am)
    public
    {
        require(Acc[msg.sender].balance >= MinSum, "Insufficient balance");
        require(Acc[msg.sender].balance >= _am, "Requested amount exceeds balance");
        require(now > Acc[msg.sender].unlockTime, "Funds are locked");

        Acc[msg.sender].balance -= _am;
        LogFile.AddMessage(msg.sender, _am, "Collect");

        msg.sender.transfer(_am);
    }

    function() 
    public 
    payable
    {
        Put(0);
    }
}


contract Log 
{
    struct Message
    {
        address Sender;
        string  Data;
        uint Val;
        uint  Time;
    }

    Message[] public History;

    function AddMessage(address _adr,uint _val,string _data)
    public
    {
        Message memory newMessage = Message(_adr, _data, _val, now);
        History.push(newMessage);
    }
}