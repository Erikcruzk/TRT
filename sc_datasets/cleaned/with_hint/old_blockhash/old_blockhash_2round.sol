pragma solidity ^0.4.24;

contract PredictTheBlockHashChallenge {

struct guess {
uint block;
bytes32 guess;
}

mapping(address => guess) guesses;

address public oracle;
bytes32 public answer;

constructor(address _oracle) public payable {
require(msg.value == 1 ether);
oracle = _oracle;
}

function lockInGuess(bytes32 hash) public payable {
require(guesses[msg.sender].block == 0);
require(msg.value == 1 ether);

guesses[msg.sender].guess = hash;
guesses[msg.sender].block  = block.number + 1;
}

function settle() public {
require(block.number > guesses[msg.sender].block);
require(oracle != address(0));

answer = bytes32(uint256(keccak256(abi.encodePacked(blockhash(guesses[msg.sender].block), oracle))));
guesses[msg.sender].block = 0;

if (guesses[msg.sender].guess == answer) {
msg.sender.transfer(2 ether);
}
}
}