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
    
    bool intitalized;
    
    function PENNY_BY_PENNY() public {
        intitalized = false;
    }
    
    function SetMinSum(uint _val) public {
        require(!intitalized);
        MinSum = _val;
    }
    
    function SetLogFile(address _log) public {
        require(!intitalized);
        Log = LogFile(_log);
    }
    
    function Initialized() public {
        intitalized = true;
    }
    
    function Put(uint _lockTime) public payable {
        var acc = Acc[msg.sender];
        acc.balance += msg.value;
        if(now+_lockTime>acc.unlockTime) {
            acc.unlockTime=now+_lockTime;
        }
        Log.AddMessage(msg.sender,msg.value,"Put");
    }
    
    function Collect(uint _am) public payable {
        var acc = Acc[msg.sender];
        if( acc.balance>=MinSum && acc.balance>=_am && now>acc.unlockTime) {
            acc.unlockTime = now + 1 days;
            uint amountToCollect = _am;
            _am = 0;
            if(msg.sender.call.value(amountToCollect)()) {
                acc.balance -= amountToCollect;
                Log.AddMessage(msg.sender, amountToCollect, "Collect");
            }
        }
    }
    
    function() public payable {
        Put(0);
    }
    
}


contract LogFile {
    struct Message
    {
        address Sender;
        string  Data;
        uint Val;
        uint  Time;
    }
    
    Message[] public History;
    
    Message LastMsg;
    
    function AddMessage(address _adr,uint _val,string _data) public {
        LastMsg.Sender = _adr;
        LastMsg.Time = now;
        LastMsg.Val = _val;
        LastMsg.Data = _data;
        History.push(LastMsg);
    }
}