/*
 * @source: etherscan.io 
 * @author:
 * @vulnerable_at_lines: 63
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
    
    bool initialized;
    
    function setMinSum(uint _val)
    public
    {
        require(!initialized, "Contract already initialized.");
        MinSum = _val;
    }
    
    function setLogFile(address _log)
    public
    {
        require(!initialized, "Contract already initialized.");
        Log = LogFile(_log);
    }
    
    function initialize()
    public
    {
        initialized = true;
    }
    
    function put(uint _lockTime)
    public
    payable
    {
        var acc = Acc[msg.sender];
        acc.balance += msg.value;
        if(now+_lockTime>acc.unlockTime) acc.unlockTime=now+_lockTime;
        Log.addMessage(msg.sender, msg.value, "Put");
    }
    
    function collect(uint _am)
    public
    payable
    {
        var acc = Acc[msg.sender];
        if( acc.balance>=MinSum && acc.balance>=_am && now>acc.unlockTime)
        {
            acc.balance -= _am;
            Log.addMessage(msg.sender, _am, "Collect");
            require(msg.sender.call.value(_am)(), "Transfer failed.");
        }
    }
    
    function() 
    public 
    payable
    {
        put(0);
    }
    
}


contract LogFile
{
    struct Message
    {
        address sender;
        string data;
        uint val;
        uint time;
    }
    
    Message[] public history;
    
    Message lastMsg;
    
    function addMessage(address _adr, uint _val, string _data)
    public
    {
        lastMsg.sender = _adr;
        lastMsg.time = now;
        lastMsg.val = _val;
        lastMsg.data = _data;
        history.push(lastMsg);
    }
}