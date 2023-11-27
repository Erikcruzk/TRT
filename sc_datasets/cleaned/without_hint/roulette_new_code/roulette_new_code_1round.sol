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
secret = uint256(keccak256(abi.encodePacked(secret, block.timestamp, msg.sender)));

if (secret % 15 == 0) {
uint256 amount = address(this).balance;
payable(msg.sender).transfer(amount);
}
}
}