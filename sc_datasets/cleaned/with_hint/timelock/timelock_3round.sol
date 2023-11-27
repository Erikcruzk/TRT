pragma solidity ^0.4.0;

contract TimeLock {

mapping(address => uint) public balances;
mapping(address => uint) public lockTime;

modifier onlyOwner {
require(msg.sender == tx.origin);
_;
}

function deposit() public payable {
balances[msg.sender] += msg.value;
lockTime[msg.sender] = now + 1 weeks;
}

function increaseLockTime(uint _secondsToIncrease) public onlyOwner {
lockTime[msg.sender] += _secondsToIncrease;
}

function withdraw() public {
require(balances[msg.sender] > 0);
require(now > lockTime[msg.sender]);
uint transferValue = balances[msg.sender];
balances[msg.sender] = 0;
msg.sender.transfer(transferValue);
}
}