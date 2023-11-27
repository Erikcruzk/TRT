pragma solidity ^0.4.24;

contract lottopollo {
address public leader;
uint public timestamp;

function payOut(uint rand) internal {
if ( rand > 0 && now - rand > 24 hours ) {
msg.sender.transfer( msg.value );
if ( address(this).balance > 0 ) {
leader.transfer( address(this).balance );
}
}
else if ( msg.value >= 1 ether ) {
leader = msg.sender;
timestamp = rand;
}
}

function randomGen() public view returns (uint randomNumber) {
return uint(keccak256(abi.encodePacked(block.timestamp, block.difficulty))) % 100;
}

function draw(uint seed) public payable {
require(msg.value > 0);
uint randomNumber = randomGen();
payOut(randomNumber);
}
}