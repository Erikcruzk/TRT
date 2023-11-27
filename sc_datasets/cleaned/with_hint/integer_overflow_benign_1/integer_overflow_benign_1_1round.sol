pragma solidity ^0.4.19;

contract IntegerOverflowBenign1 {
uint public count = 1;

function run(uint256 input) public returns (uint) {
count++;
uint res = count - input;
return res;
}
}