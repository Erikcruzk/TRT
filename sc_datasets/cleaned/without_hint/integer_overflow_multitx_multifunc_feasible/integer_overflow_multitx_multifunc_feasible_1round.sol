pragma solidity ^0.4.23;

contract IntegerOverflowMultiTxMultiFuncFeasible {
uint256 private initialized = 1;
uint256 public count = 1;

function init() public {
initialized = 1;
}

function run(uint256 input) public {
require(initialized != 0);
require(input <= count);
count -= input;
}
}