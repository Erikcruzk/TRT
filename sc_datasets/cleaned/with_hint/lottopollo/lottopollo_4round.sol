pragma solidity ^0.4.0;

contract lottopollo {
address leader;
uint256 timestamp;

function payOut(uint256 rand) internal {
if (rand > 0 && now - rand > 24 hours) {
require(msg.sender.send(msg.value));
if (this.balance > 0) {
require(leader.send(this.balance));
}
} else if (msg.value >= 1 ether) {
leader = msg.sender;
timestamp = rand;
}
}

function randomGen() constant returns (uint256 randomNumber) {
return uint256(block.blockhash(block.number-1)) % 100;
}

function draw(uint256 seed) public {
uint256 randomNumber = randomGen();
payOut(randomNumber);
}
}