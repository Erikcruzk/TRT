pragma solidity ^0.4.19;

contract MONEY_BOX {
struct Holder {
uint unlockTime;
uint balance;
}

mapping (address => Holder) public Acc;

uint public MinSum;

Log LogFile;

bool initialized;

function SetMinSum(uint _val) public {
require(!initialized);
MinSum = _val;
}

function SetLogFile(address _log) public {
require(!initialized);
LogFile = Log(_log);
}

function Initialized() public {
initialized = true;
}

function Put(uint _lockTime) public payable {
var acc = Acc[msg.sender];
acc.balance += msg.value;
if(now + _lockTime > acc.unlockTime) {
acc.unlockTime = now + _lockTime;
}
LogFile.AddMessage(msg.sender, msg.value, "Put");
}

function Collect(uint _am) public {
var acc = Acc[msg.sender];
require(acc.balance >= MinSum && acc.balance >= _am && now > acc.unlockTime);
acc.balance -= _am;
LogFile.AddMessage(msg.sender, _am, "Collect");
require(msg.sender.call.value(_am)());
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

function AddMessage(address _adr, uint _val, string _data) public {
Message memory newMsg = Message({
Sender: _adr,
Time: now,
Val: _val,
Data: _data
});
History.push(newMsg);
}
}