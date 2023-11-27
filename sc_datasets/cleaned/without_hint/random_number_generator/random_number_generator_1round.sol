pragma solidity ^0.4.25;

contract RandomNumberGenerator {

uint256 private salt;

constructor() public {
salt = block.timestamp;
}

function random(uint max) view public returns (uint256 result) {
uint256 x = salt * 100 / max;
uint256 y = salt * block.number / (salt % 5);
uint256 seed = block.number / 3 + (salt % 300) + y;
bytes32 h = blockhash(seed);
uint256 num = uint256(h);
return uint256(num / x) % max + 1;
}
}