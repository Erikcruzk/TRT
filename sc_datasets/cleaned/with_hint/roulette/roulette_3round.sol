pragma solidity ^0.4.25;

contract Roulette {
uint public pastBlockTime;
uint private seed;

constructor() public payable {}

function () public payable {
require(msg.value == 10 ether);
require(now > pastBlockTime);

pastBlockTime = now;
seed = uint(keccak256(abi.encodePacked(seed, blockhash(block.number - 1), now)));
if(seed % 15 == 0) {
msg.sender.transfer(address(this).balance);
}
}
}