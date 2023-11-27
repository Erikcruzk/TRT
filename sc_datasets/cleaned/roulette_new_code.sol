pragma solidity ^0.4.25;

contract Roulette {
uint public pastBlockTime;

constructor() public payable {}


function () public payable {
require(msg.value == 10 ether);

require(block.timestamp != pastBlockTime);

pastBlockTime = block.timestamp;


uint rand = uint(keccak256(abi.encodePacked(block.timestamp, block.difficulty))) % 15;
if(rand == 0) {
msg.sender.transfer(address(this).balance);
}
}
}
pragma solidity ^0.8.0;

contract Roulette {
uint public pastBlockTime;

constructor() payable {}

receive() external payable {
require(msg.value == 10 ether, "Bet amount should be exactly 10 ether");

require(block.timestamp != pastBlockTime, "Cannot bet multiple times in the same block");

pastBlockTime = block.timestamp;


uint rand = uint(keccak256(abi.encode(block.timestamp, block.difficulty))) % 15;
if(rand == 0) {
payable(msg.sender).transfer(address(this).balance);
}
}
}



pragma solidity ^0.8.0;

contract Roulette {
uint public pastBlockTime;

constructor() payable {}

receive() external payable {
require(msg.value == 10 ether, "Bet amount should be exactly 10 ether");

require(block.timestamp != pastBlockTime, "Cannot bet multiple times in the same block");

pastBlockTime = block.timestamp;

uint rand = uint(keccak256(abi.encodePacked(block.timestamp, block.difficulty, msg.sender))) % 15;
if(rand == 0) {
payable(msg.sender).transfer(20 ether);
}
}
} */

pragma solidity ^0.4.25;

contract Roulette {
uint256 public pastBlockTime;
uint256 private secret;

constructor() public payable {
secret = uint256(blockhash(block.number - 1));
}

function () public payable {
require(msg.value == 10 ether);

require(now != pastBlockTime);

pastBlockTime = now;
if (secret % 15 == 0) {
uint256 amount = address(this).balance;
msg.sender.transfer(amount);
}
secret = uint256(blockhash(block.number - 1));
}
}