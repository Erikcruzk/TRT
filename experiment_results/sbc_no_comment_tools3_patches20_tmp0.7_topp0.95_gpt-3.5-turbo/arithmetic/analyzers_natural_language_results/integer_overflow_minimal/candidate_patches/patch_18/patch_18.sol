pragma solidity ^0.4.19;

contract IntegerOverflowMinimal {
    uint public count = 1;

    function run(uint256 input) public {
        require(count >= input); // check if count is greater than or equal to input
        count -= input;
    }
}