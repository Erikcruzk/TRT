pragma solidity ^0.4.19;

contract IntegerOverflowAdd {
uint public count = 1;

function run(uint256 input) public {
require(input + count > count);
count += input;
}
}