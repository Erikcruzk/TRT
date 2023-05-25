pragma solidity ^0.4.23;

contract IntegerOverflowSingleTransaction {
    uint public count = 1;

    function overflowaddtostate(uint256 input) public {
        require(input + count > count); // check for overflow
        count += input;
    }

    function overflowmultostate(uint256 input) public {
        require(input == 0 || input * count / input == count); // check for overflow
        count *= input;
    }

    function underflowtostate(uint256 input) public {
        require(input <= count); // check for underflow
        count -= input;
    }

    function overflowlocalonly(uint256 input) public {
        require(input + count > count); // check for overflow
        uint res = count + input;
    }

    function overflowmulocalonly(uint256 input) public {
        require(input == 0 || input * count / input == count); // check for overflow
        uint res = count * input;
    }

    function underflowlocalonly(uint256 input) public {
        require(input <= count); // check for underflow
        uint res = count - input;
    }
}