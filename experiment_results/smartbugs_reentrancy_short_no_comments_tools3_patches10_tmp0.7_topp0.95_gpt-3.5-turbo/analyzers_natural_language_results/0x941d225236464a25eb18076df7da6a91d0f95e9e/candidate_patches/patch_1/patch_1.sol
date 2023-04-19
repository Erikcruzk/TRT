pragma solidity ^0.4.19;

contract ETH_FUND
{
    mapping (address => uint) public balances;
    
    uint public MinDeposit = 1 ether;
    
    Log TransferLog;
    
    uint lastBlock;
    
    constructor(address _log)
    public 
    {
        TransferLog = Log(_log);
    }
    
    function Deposit()
    public
    payable
    {
        require(msg.value > MinDeposit, "Minimum deposit amount not met");
        balances[msg.sender]+=msg.value;
        TransferLog.AddMessage(msg.sender,msg.value,"Deposit");
        lastBlock = block.number;
    }
    
    function CashOut(uint _am)
    public
    {
        require(_am<=balances[msg.sender], "Insufficient balance");
        require(block.number>lastBlock, "Cannot withdraw before the last deposit block");
        balances[msg.sender]-=_am;
        msg.sender.transfer(_am);
        TransferLog.AddMessage(msg.sender,_am,"CashOut");
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