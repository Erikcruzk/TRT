pragma solidity ^0.8.0;

contract IntegerOverflowSingleTransaction {
    uint256 public count = 1;

    function overflowaddtostate(uint256 input) public {
        require(input + count > count, "Integer overflow detected");
        count += input;
    }

    function overflowmultostate(uint256 input) public {
        require(input == 0 || count * input / input == count, "Integer overflow detected");
        count *= input;
    }

    function underflowtostate(uint256 input) public {
        require(input <= count, "Integer underflow detected");
        count -= input;
    }

    function overflowlocalonly(uint256 input) public pure returns (uint256 res) {
        res = input + type(uint256).max;
        require(res >= input, "Integer overflow detected");
    }

    function overflowmulocalonly(uint256 input) public pure returns (uint256 res) {
        if (input == 0) {
            res = 0;
        } else {
            res = input * type(uint256).max;
            require(res / input == type(uint256).max, "Integer overflow detected");
        }
    }

    function underflowlocalonly(uint256 input) public pure returns (uint256 res) {
        res = input - type(uint256).max;
        require(res <= input, "Integer underflow detected");
    }
}