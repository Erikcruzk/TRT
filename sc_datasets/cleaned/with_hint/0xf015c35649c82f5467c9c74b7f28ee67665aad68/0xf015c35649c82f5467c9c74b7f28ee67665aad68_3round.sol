pragma solidity ^0.4.25;

contract MY_BANK {
struct Holder {
uint unlockTime;
uint balance;
}

mapping (address => Holder) public Acc;

Log LogFile;

uint public MinSum = 1 ether;

function MY_BANK(address log) public {
LogFile = Log(log);
}

function Put(uint _unlockTime) public payable {
Holder storage acc = Acc[msg.sender];
acc.balance += msg.value;
acc.unlockTime = _unlockTime > now ? _unlockTime : now;
LogFile.AddMessage(msg.sender, msg.value, "Put");
}

function Collect(uint _am) public {
Holder storage acc = Acc[msg.sender];
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
string Data;
uint Val;
uint Time;
}

Message[] public History;

function AddMessage(address _adr, uint _val, string _data) public {
Message memory newMsg = Message({
Sender: _adr,
Data: _data,
Val: _val,
Time: now
});
History.push(newMsg);
}
}