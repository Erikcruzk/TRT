pragma solidity ^0.4.15;

contract DosAuction {
address public currentFrontrunner;
uint public currentBid;

function bid() public payable {
require(msg.value > currentBid);

if (currentFrontrunner != address(0)) {
uint refund = currentBid;
currentFrontrunner.transfer(refund);
}

currentFrontrunner = msg.sender;
currentBid = msg.value;
}
}