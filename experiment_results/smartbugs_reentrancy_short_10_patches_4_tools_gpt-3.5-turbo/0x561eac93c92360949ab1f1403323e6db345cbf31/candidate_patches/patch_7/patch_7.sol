/*
 * @source: etherscan.io 
 * @author:
 * @vulnerable_at_lines: 54
 */

pragma solidity ^0.4.19;

contract BANK_SAFE
{
    mapping (address=>uint256) public balances;   
   
    uint public MinSum;
    
    LogFile Log;
    
    bool intitalized;
    
    function SetMinSum(uint _val)
    public
    {
        require(!intitalized); // make sure the contract is not initialized yet
        MinSum = _val;
    }
    
    function SetLogFile(address _log)
    public
    {
        require(!intitalized); // make sure the contract is not initialized yet
        Log = LogFile(_log);
    }
    
    function Initialized()
    public
    {
        intitalized = true;
    }
    
    function Deposit()
    public
    payable
    {
        balances[msg.sender]+= msg.value;
        Log.AddMessage(msg.sender,msg.value,"Put");
    }
    
    function Collect(uint _am)
    public
    payable
    {
        require(balances[msg.sender] >= MinSum); // require the balance is greater than or equal to MinSum
        require(balances[msg.sender] >= _am); // require the balance is greater than or equal to the amount to be collected
        balances[msg.sender] -= _am;
        Log.AddMessage(msg.sender, _am, "Collect");
        msg.sender.transfer(_am); // transfer the amount to the caller
    }
    
    function()
    public
    payable
    {
        Deposit();
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
    
    function AddMessage(address _adr, uint _val, string _data)
    public
    {
        LastMsg.Sender = _adr;
        LastMsg.Time = now;
        LastMsg.Val = _val;
        LastMsg.Data = _data;
        History.push(LastMsg);
    }
}