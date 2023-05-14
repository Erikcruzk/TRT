pragma solidity ^0.4.19;

contract IntegerOverflowMinimal {
    uint public count = 1;

    function run(uint256 input) public {
        require(input <= count); // added a require statement to prevent underflow
        count -= input;
    }
}