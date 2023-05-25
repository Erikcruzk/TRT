pragma solidity ^0.4.23;

contract IntegerOverflowSingleTransaction {
    uint public count = 1;

    function overflowaddtostate(uint256 input) public {
        require(count + input > count); // Check for overflow
        count += input;
    }

    function overflowmultostate(uint256 input) public {
        require(input == 0 || count * input / input == count); // Check for overflow
        count *= input;
    }

    function underflowtostate(uint256 input) public {
        require(count >= input); // Check for underflow
        count -= input;
    }

    function overflowlocalonly(uint256 input) public {
        uint res = count + input;
        require(res >= count); // Check for overflow
    }

    function overflowmulocalonly(uint256 input) public {
        uint res = count * input;
        require(input == 0 || res / input == count); // Check for overflow
    }

    function underflowlocalonly(uint256 input) public {
        uint res = count - input;
        require(res <= count); // Check for underflow
    }
}