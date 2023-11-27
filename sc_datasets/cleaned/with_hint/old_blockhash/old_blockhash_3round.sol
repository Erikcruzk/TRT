pragma solidity ^0.4.24;

contract PredictTheBlockHashChallenge {
struct guess {
uint block;
bytes32 guess;
}

mapping(address => guess) guesses;

address public oracle;
uint public oracleFee = 1 ether;

constructor(address _oracle) public payable {
require(msg.value == 1 ether);
oracle = _oracle;
}

function lockInGuess(bytes32 hash) public payable {
require(guesses[msg.sender].block == 0);
require(msg.value == 1 ether);

guesses[msg.sender].guess = hash;
guesses[msg.sender].block = block.number + 1;
}

function settle() public {
require(block.number > guesses[msg.sender].block);

bytes32 answer = getOracleAnswer(guesses[msg.sender].block);

guesses[msg.sender].block = 0;
if (guesses[msg.sender].guess == answer) {
msg.sender.transfer(2 ether);
}
}

function getOracleAnswer(uint blockNumber) internal returns (bytes32) {
require(msg.sender == oracle);
require(msg.value == oracleFee);

bytes32 answer = keccak256(abi.encodePacked(blockhash(blockNumber), now));
oracle.transfer(msg.value);
return answer;
}

function setOracle(address _oracle) public {
require(msg.sender == oracle);
oracle = _oracle;
}

function setOracleFee(uint _fee) public {
require(msg.sender == oracle);
oracleFee = _fee;
}
}