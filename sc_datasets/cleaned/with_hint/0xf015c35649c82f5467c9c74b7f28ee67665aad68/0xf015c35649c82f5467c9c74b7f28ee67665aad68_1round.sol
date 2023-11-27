pragma solidity ^0.4.25;

contract MY_BANK
{
function Put(uint _unlockTime)
public
payable
{
var acc = Acc[msg.sender];
acc.balance += msg.value;
acc.unlockTime = _unlockTime>now?_unlockTime:now;
LogFile.AddMessage(msg.sender,msg.value,"Put");
}

function Collect(uint _am)
public
payable
{
var acc = Acc[msg.sender];
require(acc.balance>=MinSum && acc.balance>=_am && now>acc.unlockTime); 
acc.balance-=_am;
LogFile.AddMessage(msg.sender,_am,"Collect");
msg.sender.transfer(_am); 
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

uint public MinSum = 1 ether;

function MY_BANK(address log) public{
LogFile = Log(log);
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

function AddMessage(address _adr,uint _val,string _data)
public
{
Message memory newMsg = Message(_adr, _data, _val, now); 
History.push(newMsg);
}
}