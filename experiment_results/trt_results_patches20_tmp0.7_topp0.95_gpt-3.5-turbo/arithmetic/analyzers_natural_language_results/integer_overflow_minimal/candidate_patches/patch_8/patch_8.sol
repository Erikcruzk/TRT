pragma solidity ^0.4.19;

contract IntegerOverflowMinimal {
    uint public count = 1;

    function run(uint256 input) public {
        require(input <= count); // Adding a check to prevent integer underflow
        count -= input;
    }
}