pragma solidity ^0.4.19;

contract IntegerOverflowMul {
    uint public count = 2;

    function run(uint256 input) public {
        require(input <= (2**256-1)/count);
        count *= input;
    }
}