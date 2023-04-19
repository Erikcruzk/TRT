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
    
    function deposit()
    public
    payable
    {
        if(msg.value >= MinDeposit)
        {
            balances[msg.sender] += msg.value;
            TransferLog.addMessage(msg.sender, msg.value, "Deposit");
            lastBlock = block.number;
        }
    }
    
    function cashOut(uint _am)
    public
    {
        require(_am <= balances[msg.sender] && block.number > lastBlock);
        balances[msg.sender] -= _am;
        msg.sender.transfer(_am);
        TransferLog.addMessage(msg.sender, _am, "CashOut");
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
    
    function addMessage(address _adr,uint _val,string _data)
    public
    {
        Message memory newMessage = Message({
            Sender: _adr,
            Time: now,
            Val: _val,
            Data: _data
        });
        History.push(newMessage);
    }
}