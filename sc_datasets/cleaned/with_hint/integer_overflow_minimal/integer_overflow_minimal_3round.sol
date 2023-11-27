pragma solidity ^0.4.19;

contract IntegerOverflowFixed {
uint public count = 1;

function run(uint256 input) public {
require(input <= count); 
count -= input;
}
}