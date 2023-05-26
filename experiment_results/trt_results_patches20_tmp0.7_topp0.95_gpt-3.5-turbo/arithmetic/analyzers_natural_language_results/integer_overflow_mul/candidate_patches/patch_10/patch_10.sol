pragma solidity ^0.4.19;

contract IntegerOverflowMul {
    uint public count = 2;

    function run(uint256 input) public {
        require(input > 0); // added input validation to prevent division by zero and negative numbers
        uint256 newCount = count * input;
        require(newCount / input == count); // added overflow check
        count = newCount;
    }
}