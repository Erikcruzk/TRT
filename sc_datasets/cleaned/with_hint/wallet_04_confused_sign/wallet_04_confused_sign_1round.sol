pragma solidity ^0.4.24;

contract Wallet {
address public creator;
mapping(address => uint256) public balances;

constructor() public {
creator = msg.sender;
}

function deposit() public payable {
require(balances[msg.sender] + msg.value >= balances[msg.sender]);
balances[msg.sender] += msg.value;
}

function withdraw(uint256 amount) public {
require(amount <= balances[msg.sender]);
require(address(this).balance >= amount);
balances[msg.sender] -= amount;
msg.sender.transfer(amount);
}

function migrateTo(address to) public {
require(creator == msg.sender);
require(to != address(0));
to.transfer(address(this).balance);
}
}