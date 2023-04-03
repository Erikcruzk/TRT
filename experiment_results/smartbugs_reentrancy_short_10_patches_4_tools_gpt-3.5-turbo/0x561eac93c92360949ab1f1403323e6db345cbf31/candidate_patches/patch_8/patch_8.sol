/*
 * @source: etherscan.io 
 * @author:
 * @vulnerable_at_lines: 54
 */

pragma solidity ^0.4.19;

contract BANK_SAFE {
    mapping (address => uint256) public balances;   
    uint public MinSum;
    LogFile Log;
    bool initialized;
    mapping (address => bool) public isOwner;

    function BANK_SAFE() public {
        isOwner[msg.sender] = true;
    }

    function SetMinSum(uint _val) public {
        require(isOwner[msg.sender]);
        require(!initialized);
        MinSum = _val;
    }

    function SetLogFile(address _log) public {
        require(isOwner[msg.sender]);
        require(!initialized);
        Log = LogFile(_log);
    }

    function Initialized() public {
        require(isOwner[msg.sender]);
        initialized = true;
    }

    function Deposit() public payable {
        balances[msg.sender] += msg.value;
        Log.AddMessage(msg.sender, msg.value, "Put");
    }

    function Collect(uint _am) public payable {
        require(balances[msg.sender] >= MinSum && balances[msg.sender] >= _am);
        balances[msg.sender] -= _am;
        require(msg.sender.call.value(_am)());
        Log.AddMessage(msg.sender, _am, "Collect");
    }

    function() public payable {
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

    function AddMessage(address _adr, uint _val, string _data) public {
        LastMsg.Sender = _adr;
        LastMsg.Time = now;
        LastMsg.Val = _val;
        LastMsg.Data = _data;
        History.push(LastMsg);
    }
}