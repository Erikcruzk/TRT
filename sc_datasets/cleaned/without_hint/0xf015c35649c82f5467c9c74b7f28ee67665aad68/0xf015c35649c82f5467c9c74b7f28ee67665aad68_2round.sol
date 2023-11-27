pragma solidity ^0.4.25;

contract MY_BANK {
struct Holder {
uint unlockTime;
uint balance;
}

mapping (address => Holder) public Acc;
uint public MinSum = 1 ether;
Log LogFile;

function MY_BANK(address log) public {
LogFile = Log(log);
}

function Put(uint _unlockTime) public payable {
require(msg.value > 0, "Amount should be greater than 0");
Acc[msg.sender].balance += msg.value;
Acc[msg.sender].unlockTime = _unlockTime > now ? _unlockTime : now;
LogFile.AddMessage(msg.sender, msg.value, "Put");
}

function Collect(uint _am) public {
require(_am > 0, "Amount should be greater than 0");
var acc = Acc[msg.sender];
require(acc.balance >= MinSum, "Balance should be greater than MinSum");
require(acc.balance >= _am, "Balance should be greater than amount");
require(now > acc.unlockTime, "Unlock time should be greater than now");

acc.balance -= _am;
msg.sender.transfer(_am);
LogFile.AddMessage(msg.sender, _am, "Collect");
}

function() public payable {
Put(0);
}
}

contract Log {
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