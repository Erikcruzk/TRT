pragma solidity ^0.4.19;

contract IntegerOverflowMul {
    uint public count = 2;

    function run(uint256 input) public {
        require(input != 0); // Prevent division by zero
        uint256 newCount = count * input;
        require(newCount / input == count); // Check for overflow
        count = newCount;
    }
}