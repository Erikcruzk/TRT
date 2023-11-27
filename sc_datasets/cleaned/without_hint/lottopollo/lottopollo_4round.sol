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

function randomGen() internal view returns (uint) {
return block.timestamp;
}

function draw(uint seed) public {
uint randomNumber = uint(keccak256(abi.encodePacked(randomGen(), seed)));
payOut(randomNumber);
}
}