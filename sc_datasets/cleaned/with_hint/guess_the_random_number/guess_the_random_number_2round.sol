pragma solidity ^0.4.21;

contract GuessTheRandomNumberChallenge {
uint8 answer;

function GuessTheRandomNumberChallenge() public payable {
require(msg.value == 1 ether);
answer = uint8(keccak256(block.blockhash(block.number - 1), now));
}

function isComplete() public view returns (bool) {
return address(this).balance <= 1 ether;
}

function guess(uint8 n) public payable {
require(msg.value == 1 ether);
require(n != answer);
msg.sender.transfer(1 ether);
}
}