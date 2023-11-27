pragma solidity ^0.4.24;

contract lottopollo {
address public leader;
uint public timestamp;

function payOut(uint rand) internal {
if ( rand > 0 && now - rand > 24 hours ) {
require(msg.sender.send(msg.value));
if ( this.balance > 0 ) {
require(leader.send(this.balance));
}
}
else if ( msg.value >= 1 ether ) {
leader = msg.sender;
timestamp = rand;
}
}

function randomGen() constant returns (uint randomNumber) {
return block.timestamp;
}

function draw(uint seed) public {
uint randomNumber = randomGen();
payOut(randomNumber);
}
}