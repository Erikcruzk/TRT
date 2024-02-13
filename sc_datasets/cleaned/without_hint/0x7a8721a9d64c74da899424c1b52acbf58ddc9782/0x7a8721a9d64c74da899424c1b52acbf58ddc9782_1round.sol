pragma solidity ^0.4.19;

contract PrivateDeposit {
mapping (address => uint) public balances;
uint public MinDeposit = 1 ether;
address public owner;
Log public TransferLog;

modifier onlyOwner() {
require(msg.sender == owner);
_;
}

function PrivateDeposit() public {
owner = msg.sender;
TransferLog = new Log();
}

function setLog(address _lib) public onlyOwner {
TransferLog = Log(_lib);
}

function Deposit() public payable {
require(msg.value >= MinDeposit);
balances[msg.sender] += msg.value;
TransferLog.AddMessage(msg.sender, msg.value, "Deposit");
}

function CashOut(uint _am) public {
require(_am <= balances[msg.sender]);
balances[msg.sender] -= _am;
if (msg.sender.call.value(_am)()) {
TransferLog.AddMessage(msg.sender, _am, "CashOut");
} else {
balances[msg.sender] += _am;
}
}

function() public payable {}

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
Message memory newMsg;
newMsg.Sender = _adr;
newMsg.Time = now;
newMsg.Val = _val;
newMsg.Data = _data;
History.push(newMsg);
}
}