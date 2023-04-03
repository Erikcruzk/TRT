/*
 * @source: etherscan.io 
 * @author: -
 * @fixed_at_lines: 63
 */

pragma solidity ^0.4.19;

contract PENNY_BY_PENNY  
{
    struct Holder   
    {
        uint unlockTime;
        uint balance;
    }
    
    mapping (address => Holder) public Acc;
    
    uint public MinSum;
    
    LogFile Log;
    
    bool intitalized;
    
    function SetMinSum(uint _val)
    public
    {
        require(!intitalized); // Fix: Use require to check if the contract is not initialized
        MinSum = _val;
    }
    
    function SetLogFile(address _log)
    public
    {
        require(!intitalized); // Fix: Use require to check if the contract is not initialized
        Log = LogFile(_log);
    }
    
    function Initialized()
    public
    {
        intitalized = true;
    }
    
    function Put(uint _lockTime)
    public
    payable
    {
        var acc = Acc[msg.sender];
        acc.balance += msg.value;
        if(now+_lockTime>acc.unlockTime)acc.unlockTime=now+_lockTime;
        Log.AddMessage(msg.sender,msg.value,"Put");
    }
    
    function Collect(uint _am)
    public
    payable
    {
        var acc = Acc[msg.sender];
        if( acc.balance>=MinSum && acc.balance>=_am && now>acc.unlockTime)
        {
            // <yes> <report> REENTRANCY
            acc.unlockTime = now; // Fix: Update the unlock time first to prevent reentrancy
            uint balance = acc.balance; // Fix: Store the balance in a local variable
            acc.balance = 0; // Fix: Set the balance to zero before transferring
            if(msg.sender.call.value(_am)())
            {
                require(acc.balance == 0); // Fix: Use require to check if the balance is zero after transferring
                Log.AddMessage(msg.sender,_am,"Collect");
            }
            else
            {
                acc.balance = balance; // Fix: Restore the balance if the transfer fails
            }
        }
    }
    
    function() 
    public 
    payable
    {
        Put(0);
    }
    
}


contract LogFile
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
    
    function AddMessage(address _adr,uint _val,string _data)
    public
    {
        LastMsg.Sender = _adr;
        LastMsg.Time = now;
        LastMsg.Val = _val;
        LastMsg.Data = _data;
        History.push(LastMsg);
    }
}