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
        uint res = input + 1; // no state variable involved
        require(res > input); // check for overflow
        return res;
    }

    function overflowmulocalonly(uint256 input) public pure returns (uint) {
        uint res = input * 2; // no state variable involved
        require(res / input == 2); // check for overflow
        return res;
    }

    function underflowlocalonly(uint256 input) public pure returns (uint) {
        uint res = input - 1; // no state variable involved
        require(res < input); // check for underflow
        return res;
    }
}