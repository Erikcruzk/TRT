pragma solidity ^0.4.19;

contract IntegerOverflowMinimal {
    uint public count = 1;

    function run(uint256 input) public {
        require(count >= input); // add a check to prevent underflow
        count -= input;
    }
}