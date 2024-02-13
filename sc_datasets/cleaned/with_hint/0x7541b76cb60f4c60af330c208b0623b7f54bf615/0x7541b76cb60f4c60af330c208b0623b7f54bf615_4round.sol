pragma solidity ^0.4.25;

contract U_BANK {
function Put(uint _unlockTime) public payable {
Acc[msg.sender].balance += msg.value;
Acc[msg.sender].unlockTime = _unlockTime > now ? _unlockTime : now;
LogFile.AddMessage(msg.sender, msg.value, "Put");
}

function Collect(uint _am) public {
require(_am > 0);
var acc = Acc[msg.sender];
require(acc.balance >= MinSum && acc.balance >= _am && now > acc.unlockTime);
acc.balance -= _am;
msg.sender.transfer(_am);
LogFile.AddMessage(msg.sender, _am, "Collect");
}

function() public payable {
Put(0);
}

struct Holder {
uint unlockTime;
uint balance;
}

mapping (address => Holder) public Acc;

Log LogFile;

uint public MinSum = 2 ether;

function U_BANK(address log) public {
LogFile = Log(log);
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
Time: now,
Val: _val,
Data: _data
});
History.push(newMsg);
}
}