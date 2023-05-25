pragma solidity ^0.4.19;

contract IntegerOverflowMul {
    uint public count = 2;

    function run(uint256 input) public {
        require(input != 0, "Input must not be zero");
        uint256 result = count * input;
        require(result / count == input, "Multiplication overflow occurred");
        count = result;
    }
}