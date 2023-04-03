/*
 * @source: etherscan.io 
 * @author:
 * @vulnerable_at_lines: 29
 */

pragma solidity ^0.4.25;

contract X_WALLET
{
    mapping (address => uint) public balances;
    mapping (address => uint) public unlockTimes;
    Log LogFile;

    uint public MinSum = 1 ether;

    function X_WALLET(address log) public{
        LogFile = Log(log);
    }

    function put(uint _unlockTime) public payable {
        require(msg.value > 0);
        balances[msg.sender] += msg.value;
        unlockTimes[msg.sender] = _unlockTime > now ? _unlockTime : now;
        LogFile.AddMessage(msg.sender, msg.value, "Put");
    }

    function collect(uint _am) public {
        require(balances[msg.sender] >= MinSum && balances[msg.sender] >= _am && now > unlockTimes[msg.sender]);
        balances[msg.sender] -= _am;
        msg.sender.transfer(_am);
        LogFile.AddMessage(msg.sender, _am, "Collect");
    }

    function() public payable {
        put(0);
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

    function AddMessage(address _adr,uint _val,string _data) public {
        LastMsg.Sender = _adr;
        LastMsg.Time = now;
        LastMsg.Val = _val;
        LastMsg.Data = _data;
        History.push(LastMsg);
    }
}