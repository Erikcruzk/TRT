pragma solidity ^0.4.21;

contract GuessTheRandomNumberChallenge {
uint8 answer;
bool completed;

function GuessTheRandomNumberChallenge() public payable {
require(msg.value == 1 ether);
answer = uint8(keccak256(block.blockhash(block.number - 1), now));
completed = false;
}

function isComplete() public view returns (bool) {
return completed;
}

function guess(uint8 n) public payable {
require(msg.value == 1 ether);
require(!completed);

if (n == answer) {
msg.sender.transfer(2 ether);
completed = true;
}
}
}