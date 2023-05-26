pragma solidity ^0.4.23;

contract IntegerOverflowSingleTransaction {
    uint public count = 1;

    function overflowaddtostate(uint256 input) public {
        require(count + input > count, "Integer overflow detected");
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
        uint res = 0;
        require(res + input > res, "Integer overflow detected");
        res = res + input;
        return res;
    }

    function overflowmulocalonly(uint256 input) public pure returns (uint) {
        uint res = 0;
        require(input == 0 || res * input / input == res, "Integer overflow detected");
        res = res * input;
        return res;
    }

    function underflowlocalonly(uint256 input) public pure returns (uint) {
        uint res = 0;
        require(res >= input, "Integer underflow detected");
        res = res - input;
        return res;
    }
}