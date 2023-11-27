pragma solidity ^0.4.23;

contract IntegerOverflowSingleTransaction {
uint public count = 1;

function overflowaddtostate(uint256 input) public {
require(input + count > count);
count += input;
}

function overflowmultostate(uint256 input) public {
require(input == 0 || input * count / input == count);
count *= input;
}

function underflowtostate(uint256 input) public {
require(input <= count);
count -= input;
}

function overflowlocalonly(uint256 input) public {
require(input + count > count);
uint res = count + input;
}

function overflowmulocalonly(uint256 input) public {
require(input == 0 || input * count / input == count);
uint res = count * input;
}

function underflowlocalonly(uint256 input) public {
require(input <= count);
uint res = count - input;
}
}