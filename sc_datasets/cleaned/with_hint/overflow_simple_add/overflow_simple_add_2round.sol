pragma solidity 0.4.25;

library SafeMath {
function add(uint256 a, uint256 b) internal pure returns (uint256) {
uint256 c = a + b;
require(c >= a, "SafeMath: addition overflow");
return c;
}
}

contract Overflow_Add {
using SafeMath for uint256;
uint public balance = 1;

function add(uint256 deposit) public {
balance = balance.add(deposit);
}
}