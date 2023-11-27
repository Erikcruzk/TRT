pragma solidity ^0.4.19;

library SafeMath {
function mul(uint256 a, uint256 b) internal pure returns (uint256) {
if (a == 0) {
return 0;
}
uint256 c = a * b;
assert(c / a == b);
return c;
}
}

contract IntegerOverflowMul {
using SafeMath for uint256;

uint public count = 2;

function run(uint256 input) public {
count = count.mul(input);
}
}