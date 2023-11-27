pragma solidity ^0.8.0;

contract Roulette {
uint256 public pastBlockTime;
uint256 private secret;

constructor() payable {
secret = uint256(blockhash(block.number - 1));
}

receive() external payable {
require(msg.value == 10 ether, "Bet amount should be exactly 10 ether");
require(block.timestamp != pastBlockTime, "Cannot bet multiple times in the same block");

pastBlockTime = block.timestamp;
secret = uint256(blockhash(block.number - 1));

if (secret % 15 == 0) {
payable(msg.sender).transfer(address(this).balance);
}
}
}