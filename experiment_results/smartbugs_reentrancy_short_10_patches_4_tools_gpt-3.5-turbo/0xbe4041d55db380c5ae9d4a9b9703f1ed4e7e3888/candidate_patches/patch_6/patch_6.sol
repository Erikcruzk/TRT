/*
 * @source: etherscan.io 
 * @author:
 * @vulnerable_at_lines: 63
 */

pragma solidity ^0.4.19;

contract MONEY_BOX   
{
    struct Holder   
    {
        uint unlockTime;
        uint balance;
    }
    
    mapping (address => Holder) public Acc;
    
    uint public MinSum;
    
    Log LogFile;
    
    bool intitalized;
    
    function setMinSum(uint _val)
    public
    {
        require(!intitalized);
        MinSum = _val;
    }
    
    function setLogFile(address _log)
    public
    {
        require(!intitalized);
        LogFile = Log(_log);
    }
    
    function initialized()
    public
    {
        intitalized = true;
    }
    
    function put(uint _lockTime)
    public
    payable
    {
        var acc = Acc[msg.sender];
        acc.balance += msg.value;
        if(now+_lockTime>acc.unlockTime)acc.unlockTime=now+_lockTime;
        LogFile.addMessage(msg.sender,msg.value,"Put");
    }
    
    function collect(uint _am)
    public
    payable
    {
        var acc = Acc[msg.sender];
        require(acc.balance>=MinSum && acc.balance>=_am && now>acc.unlockTime);
        acc.balance-=_am;
        msg.sender.transfer(_am);
        LogFile.addMessage(msg.sender,_am,"Collect");
    }
    
    function() 
    public 
    payable
    {
        put(0);
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
    
    Message LastMsg;
    
    function addMessage(address _adr,uint _val,string _data)
    public
    {
        LastMsg.Sender = _adr;
        LastMsg.Time = now;
        LastMsg.Val = _val;
        LastMsg.Data = _data;
        History.push(LastMsg);
    }
}