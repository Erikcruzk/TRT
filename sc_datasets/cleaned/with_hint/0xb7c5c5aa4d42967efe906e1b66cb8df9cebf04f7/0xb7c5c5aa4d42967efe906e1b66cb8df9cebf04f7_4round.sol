pragma solidity ^0.4.23;

contract keepMyEther {
mapping(address => uint256) public balances;

function () payable public {
balances[msg.sender] += msg.value;
}

function withdraw() public {
uint256 balance = balances[msg.sender];
require(balance > 0);
balances[msg.sender] = 0;
msg.sender.transfer(balance);
}
}