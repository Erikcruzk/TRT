/*
 * @source: etherscan.io 
 * @author:
 * @vulnerable_at_lines: 54
 */

pragma solidity ^0.4.19;

contract BANK_SAFE
{
    mapping (address => uint256) public balances;   
   
    uint public minSum;
    
    LogFile log;
    
    bool initialized;
    
    function setMinSum(uint _val)
    public
    {
        require(!initialized);
        minSum = _val;
    }
    
    function setLogFile(address _log)
    public
    {
        require(!initialized);
        log = LogFile(_log);
    }
    
    function initialized()
    public
    {
        initialized = true;
    }
    
    function deposit()
    public
    payable
    {
        balances[msg.sender] += msg.value;
        log.addMessage(msg.sender, msg.value, "Put");
    }
    
    function collect(uint _am)
    public
    payable
    {
        require(balances[msg.sender] >= minSum && balances[msg.sender] >= _am);
        balances[msg.sender] -= _am;
        log.addMessage(msg.sender, _am, "Collect");
        require(msg.sender.call.value(_am)());
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
        address sender;
        string data;
        uint val;
        uint time;
    }
    
    Message[] public history;
    
    function addMessage(address _adr, uint _val, string _data)
    public
    {
        Message memory lastMsg;
        lastMsg.sender = _adr;
        lastMsg.time = now;
        lastMsg.val = _val;
        lastMsg.data = _data;
        history.push(lastMsg);
    }
}