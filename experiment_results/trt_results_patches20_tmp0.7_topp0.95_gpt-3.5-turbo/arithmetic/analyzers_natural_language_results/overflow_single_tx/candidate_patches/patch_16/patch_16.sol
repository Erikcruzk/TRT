pragma solidity ^0.8.0;

contract IntegerOverflowSingleTransaction {
    uint public count = 1;

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

    function overflowlocalonly(uint256 input) public pure returns (uint) {
        uint res = input + 1;
        require(res > input, "Integer overflow detected");
        return res;
    }

    function overflowmulocalonly(uint256 input) public pure returns (uint) {
        uint res = input * 2;
        require(res / 2 == input, "Integer overflow detected");
        return res;
    }

    function underflowlocalonly(uint256 input) public pure returns (uint) {
        uint res = input - 1;
        require(res < input, "Integer underflow detected");
        return res;
    }
}