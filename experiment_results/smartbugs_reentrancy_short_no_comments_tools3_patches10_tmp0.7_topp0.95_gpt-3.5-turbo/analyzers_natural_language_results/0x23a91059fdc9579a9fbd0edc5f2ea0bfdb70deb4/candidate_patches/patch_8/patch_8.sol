pragma solidity ^0.4.19;

contract PrivateBank
{
    mapping (address => uint) public balances;
    
    uint public MinDeposit = 1 ether;
    
    Log TransferLog;
    
    function PrivateBank(address _log)
    {
        TransferLog = Log(_log);
    }
    
    function Deposit()
    public
    payable
    {
        require(msg.value >= MinDeposit); // add require statement to ensure minimum deposit is met
        balances[msg.sender]+=msg.value;
        TransferLog.AddMessage(msg.sender,msg.value,"Deposit");
    }
    
    function CashOut(uint _am)
    {
        require(_am<=balances[msg.sender]); // add require statement to ensure user has sufficient balance
        balances[msg.sender]-=_am;
        TransferLog.AddMessage(msg.sender,_am,"CashOut");
        msg.sender.transfer(_am); // use transfer() instead of call.value() to prevent reentrancy vulnerability
    }
    
    function() public payable{}    
    
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
        Message memory newMsg = Message({Sender: _adr, Data: _data, Val: _val, Time: now}); // create new Message struct instead of reusing old one
        History.push(newMsg);
    }
}