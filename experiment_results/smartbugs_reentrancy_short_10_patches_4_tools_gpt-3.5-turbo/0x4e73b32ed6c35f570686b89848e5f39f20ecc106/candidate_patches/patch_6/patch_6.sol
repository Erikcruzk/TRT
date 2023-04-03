/*
 * @source: etherscan.io 
 * @author:
 * @vulnerable_at_lines: 54
 */

pragma solidity ^0.4.19;

contract PRIVATE_ETH_CELL {
    mapping (address => uint256) public balances;   
    uint public MinSum;
    LogFile Log;
    bool initialized;
    mapping (address => bool) public canWithdraw;

    function SetMinSum(uint _val)
    public {
        require(!initialized);
        MinSum = _val;
    }
    
    function SetLogFile(address _log)
    public {
        require(!initialized);
        Log = LogFile(_log);
    }
    
    function Initialized()
    public {
        initialized = true;
    }
    
    function Deposit()
    public
    payable {
        balances[msg.sender] += msg.value;
        Log.AddMessage(msg.sender, msg.value, "Put");
    }
    
    function Collect(uint _am)
    public {
        if (balances[msg.sender] >= MinSum && balances[msg.sender] >= _am && canWithdraw[msg.sender]) {
            canWithdraw[msg.sender] = false;
            balances[msg.sender] -= _am;
            Log.AddMessage(msg.sender, _am, "Collect");
            msg.sender.transfer(_am);
            canWithdraw[msg.sender] = true;
        }
    }
    
    function()
    public 
    payable {
        Deposit();
    }
    
}

contract LogFile {
    struct Message {
        address Sender;
        string  Data;
        uint Val;
        uint  Time;
    }
    
    Message[] public History;
    
    Message LastMsg;
    
    function AddMessage(address _adr, uint _val, string _data)
    public {
        LastMsg.Sender = _adr;
        LastMsg.Time = now;
        LastMsg.Val = _val;
        LastMsg.Data = _data;
        History.push(LastMsg);
    }
}