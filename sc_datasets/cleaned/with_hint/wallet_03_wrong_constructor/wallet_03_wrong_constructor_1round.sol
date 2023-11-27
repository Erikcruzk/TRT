pragma solidity ^0.4.24;

contract Wallet {
address payable creator;
mapping(address => uint256) balances;

constructor() public {
creator = msg.sender;
}

function deposit() public payable {
require(balances[msg.sender] + msg.value > balances[msg.sender]);
balances[msg.sender] += msg.value;
}

function withdraw(uint256 amount) public payable {
require(amount <= balances[msg.sender]);
msg.sender.transfer(amount);
balances[msg.sender] -= amount;
}

function migrateTo(address payable to) public {
require(creator == msg.sender);
to.transfer(address(this).balance);
}
}