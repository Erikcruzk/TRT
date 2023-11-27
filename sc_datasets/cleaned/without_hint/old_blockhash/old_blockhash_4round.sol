pragma solidity ^0.4.24;

contract PredictTheBlockHashChallenge {
struct Guess {
uint block;
bytes32 guess;
}

mapping(address => Guess) public guesses;

constructor() public payable {
require(msg.value == 1 ether);
}

function lockInGuess(bytes32 hash) public payable {
require(guesses[msg.sender].block == 0);
require(msg.value == 1 ether);

guesses[msg.sender] = Guess({
block: block.number + 1,
guess: hash
});
}

function settle() public {
require(guesses[msg.sender].block != 0);
require(block.number > guesses[msg.sender].block);

bytes32 answer = blockhash(guesses[msg.sender].block);

if (guesses[msg.sender].guess == answer) {
msg.sender.transfer(2 ether);
}

delete guesses[msg.sender];
}
}