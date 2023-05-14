pragma solidity ^0.4.23;

contract IntegerOverflowSingleTransaction {
    uint public count = 1;

    function overflowaddtostate(uint256 input) public {
        require(input + count > count); // check for overflow
        count += input;
    }

    function overflowmultostate(uint256 input) public {
        require(input == 0 || count * input / input == count); // check for overflow
        count *= input;
    }

    function underflowtostate(uint256 input) public {
        require(input <= count); // check for underflow
        count -= input;
    }

    function overflowlocalonly(uint256 input) public pure returns (uint) {
        uint res = 0;
        require(input + res > res); // check for overflow
        res += input;
        return res;
    }

    function overflowmulocalonly(uint256 input) public pure returns (uint) {
        uint res = 0;
        require(input == 0 || res * input / input == res); // check for overflow
        res *= input;
        return res;
    }

    function underflowlocalonly(uint256 input) public pure returns (uint) {
        uint res = 0;
        require(input <= res); // check for underflow
        res -= input;
        return res;
    }
}