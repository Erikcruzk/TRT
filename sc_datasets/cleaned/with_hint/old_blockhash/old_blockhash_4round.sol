pragma solidity ^0.4.24;

contract PredictTheBlockHashChallenge {
struct guess {
uint block;
bytes32 guess;
}

mapping(address => guess) guesses;

address public oracle;
uint public random;

constructor(address _oracle) public payable {
require(msg.value == 1 ether);
oracle = _oracle;
}

function lockInGuess(bytes32 hash) public payable {
require(guesses[msg.sender].block == 0);
require(msg.value == 1 ether);

guesses[msg.sender].guess = hash;
guesses[msg.sender].block = random + 1;
}

function settle() public {
require(guesses[msg.sender].block != 0);
require(block.number > guesses[msg.sender].block);

bytes32 answer = keccak256(abi.encodePacked(random));

guesses[msg.sender].block = 0;
if (guesses[msg.sender].guess == answer) {
msg.sender.transfer(2 ether);
}
}

function updateRandom() public {
require(msg.sender == oracle);
random = uint(keccak256(abi.encodePacked(blockhash(block.number - 1), now)));
}
}