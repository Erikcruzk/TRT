pragma solidity ^0.4.23;

contract IntegerOverflowSingleTransaction {
    uint256 public count = 1;

    function overflowAddToState(uint256 input) public {
        require(count + input > count); // check for overflow
        count += input;
    }

    function overflowMulToState(uint256 input) public {
        require(input == 0 || count * input / input == count); // check for overflow
        count *= input;
    }

    function underflowToState(uint256 input) public {
        require(count >= input); // check for underflow
        count -= input;
    }

    function overflowLocalOnly(uint256 input) public pure returns (uint256) {
        uint256 res = input + 1;
        require(res > input); // check for overflow
        return res;
    }

    function overflowMulLocalOnly(uint256 input) public pure returns (uint256) {
        uint256 res = input * 2;
        require(res / 2 == input); // check for overflow
        return res;
    }

    function underflowLocalOnly(uint256 input) public pure returns (uint256) {
        uint256 res = input - 1;
        require(res < input); // check for underflow
        return res;
    }
}