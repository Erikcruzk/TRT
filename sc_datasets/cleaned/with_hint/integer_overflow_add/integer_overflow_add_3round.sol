pragma solidity ^0.4.19;

library SafeMath {
function add(uint256 a, uint256 b) internal pure returns (uint256) {
uint256 c = a + b;
require(c >= a);
return c;
}
}

contract IntegerOverflowAdd {
using SafeMath for uint256;
uint public count = 1;

function run(uint256 input) public {
count = count.add(input);
}
}