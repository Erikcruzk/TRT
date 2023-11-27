pragma solidity ^0.4.19;

library SafeMath {
function sub(uint256 a, uint256 b) internal pure returns (uint256) {
assert(b <= a);
return a - b;
}
}

contract IntegerOverflowBenign1 {
using SafeMath for uint256;

uint public count = 1;

function run(uint256 input) public {
uint res = count.sub(input);
}
}