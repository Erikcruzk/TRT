pragma solidity ^0.4.23;

contract IntegerOverflowSingleTransaction {
    uint public count = 1;

    function overflowaddtostate(uint256 input) public {
        require(input + count > count); // prevent integer overflow
        count += input;
    }

    function overflowmultostate(uint256 input) public {
        require(input == 0 || count * input / input == count); // prevent integer overflow
        count *= input;
    }

    function underflowtostate(uint256 input) public {
        require(input <= count); // prevent integer underflow
        count -= input;
    }

    function overflowlocalonly(uint256 input) public pure returns (uint) {
        uint res = input + 1; // just a local variable, no need to prevent overflow
        return res;
    }

    function overflowmulocalonly(uint256 input) public pure returns (uint) {
        uint res = input * 2; // just a local variable, no need to prevent overflow
        return res;
    }

    function underflowlocalonly(uint256 input) public pure returns (uint) {
        uint res = input - 1; // just a local variable, no need to prevent underflow
        return res;
    }
}