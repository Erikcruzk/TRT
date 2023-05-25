pragma solidity ^0.8.0;

contract IntegerOverflowSingleTransaction {
    uint256 public count = 1;

    function overflowAddToState(uint256 input) public {
        require(input + count > count, "Integer overflow detected");
        count += input;
    }

    function overflowMulToState(uint256 input) public {
        require(input == 0 || count * input / input == count, "Integer overflow detected");
        count *= input;
    }

    function underflowToState(uint256 input) public {
        require(input <= count, "Integer underflow detected");
        count -= input;
    }

    function overflowLocalOnly(uint256 input) public pure returns (uint256) {
        uint256 res = input + 1;
        require(res > input, "Integer overflow detected");
        return res;
    }

    function overflowMulLocalOnly(uint256 input) public pure returns (uint256) {
        uint256 res = input * 2;
        require(res / 2 == input, "Integer overflow detected");
        return res;
    }

    function underflowLocalOnly(uint256 input) public pure returns (uint256) {
        uint256 res = input - 1;
        require(res < input, "Integer underflow detected");
        return res;
    }
}