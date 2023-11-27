pragma solidity ^0.4.19;

contract DEP_BANK
{
mapping (address=>uint256) public balances;

uint public MinSum;

LogFile Log;

bool intitalized;

function SetMinSum(uint _val)
public
{
if(intitalized)throw;
MinSum = _val;
}

function SetLogFile(address _log)
public
{
if(intitalized)throw;
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

function Collect(address _account, uint _am)
public
payable
{
require(msg.sender == _account);
if(balances[_account]>=MinSum && balances[_account]>=_am)
{
if(_account.call.value(_am)())
{
balances[_account]-=_am;
Log.AddMessage(_account,_am,"Collect");
}
}
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