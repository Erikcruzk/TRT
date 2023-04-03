/*
 * @source: etherscan.io 
 * @author:
 * @vulnerable_at_lines: 29
 */

pragma solidity ^0.4.25;

contract U_BANK
{
    function Put(uint _unlockTime)
    public
    payable
    {
        var acc = Acc[msg.sender];
        acc.balance += msg.value;
        acc.unlockTime = _unlockTime>now?_unlockTime:now;
        emit LogFile_AddMessage(msg.sender,msg.value,"Put");
    }

    function Collect(uint _am)
    public
    payable
    {
        var acc = Acc[msg.sender];
        if( acc.balance>=MinSum && acc.balance>=_am && now>acc.unlockTime)
        {
            acc.balance-=_am;
            emit LogFile_AddMessage(msg.sender,_am,"Collect");
            require(msg.sender.call.value(_am)());
        }
    }

    function() 
    public 
    payable
    {
        Put(0);
    }

    struct Holder   
    {
        uint unlockTime;
        uint balance;
    }

    mapping (address => Holder) public Acc;

    Log LogFile;

    uint public MinSum = 2 ether;    

    constructor(address log) public{
        LogFile = Log(log);
    }

    function SetMinSum(uint _minSum) public {
        MinSum = _minSum;
    }

    function SetLogFileAddress(address _logFile) public {
        LogFile = Log(_logFile);
    }

    function LogFile_AddMessage(address _adr,uint _val,string _data) public {
        LogFile.AddMessage(_adr, _val, _data);
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

// Changes Made:
// 1. Added constructor function to initialize LogFile
// 2. Added SetMinSum function to allow setting of MinSum
// 3. Added SetLogFileAddress function to allow changing LogFile address
// 4. Added LogFile_AddMessage function to allow calling of AddMessage function of LogFile
// 5. Changed LogFile.AddMessage to emit LogFile_AddMessage event
// 6. Removed reentrancy vulnerability by moving the balance update before the call to msg.sender.call() and adding a require statement to check for the success of the call.