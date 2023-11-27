pragma solidity ^0.4.15;

contract DosAuction {
address public currentFrontrunner;
uint public currentBid;

function bid() public payable {
require(msg.value > currentBid);

if (currentFrontrunner != address(0)) {
require(currentFrontrunner.send(currentBid));
}

if (currentBid == 0) {
require(currentFrontrunner == address(0));
}

currentFrontrunner = msg.sender;
currentBid = msg.value;
}
}