pragma solidity ^0.4.25;

contract Roulette {
uint public pastBlockTime;

constructor() public payable {}

function () public payable {
require(msg.value == 10 ether);
require(block.timestamp != pastBlockTime);
pastBlockTime = block.timestamp;
if(block.timestamp % 15 == 0) {
msg.sender.transfer(address(this).balance);
}
}
}