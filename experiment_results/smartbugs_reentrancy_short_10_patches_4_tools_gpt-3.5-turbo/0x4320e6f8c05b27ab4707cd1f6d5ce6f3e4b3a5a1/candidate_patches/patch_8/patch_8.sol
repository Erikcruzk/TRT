/*
 * @source: etherscan.io 
 * @author: -
 * @vulnerable_at_lines: 55
 */

pragma solidity ^0.4.19;

contract ACCURAL_DEPOSIT
{
    mapping (address=>uint256) public balances;   
   
    uint public MinSum = 1 ether;
    
    LogFile Log;
    
    bool initialized;
    
    function setMinSum(uint _val)
    public
    {
        require(!initialized);
        MinSum = _val;
    }
    
    function setLogFile(address _log)
    public
    {
        require(!initialized);
        Log = LogFile(_log);
    }
    
    function initialize()
    public
    {
        initialized = true;
    }
    
    function deposit()
    public
    payable
    {
        balances[msg.sender] += msg.value;
        Log.addMessage(msg.sender, msg.value, "Put");
    }
    
    function collect(uint _am)
    public
    payable
    {
        if(balances[msg.sender] >= MinSum && balances[msg.sender] >= _am)
        {
            balances[msg.sender] -= _am;
            Log.addMessage(msg.sender, _am, "Collect");
            require(msg.sender.call.value(_am)());
        }
    }
    
    function() 
    public 
    payable
    {
        deposit();
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
    
    function addMessage(address _adr, uint _val, string _data)
    public
    {
        Message memory newMessage;
        newMessage.Sender = _adr;
        newMessage.Time = now;
        newMessage.Val = _val;
        newMessage.Data = _data;
        History.push(newMessage);
    }
}