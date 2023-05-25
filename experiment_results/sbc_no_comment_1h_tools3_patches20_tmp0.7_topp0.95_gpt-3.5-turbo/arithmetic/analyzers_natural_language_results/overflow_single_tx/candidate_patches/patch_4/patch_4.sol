pragma solidity ^0.4.23;

contract IntegerOverflowSingleTransaction {
    uint public count = 1;

    function overflowaddtostate(uint256 input) public {
        require(count + input >= count); // check for overflow
        count += input;
    }

    function overflowmultostate(uint256 input) public {
        require(count * input / input == count); // check for overflow
        count *= input;
    }

    function underflowtostate(uint256 input) public {
        require(count - input <= count); // check for underflow
        count -= input;
    }

    function overflowlocalonly(uint256 input) public {
        uint res = count + input;
        require(res >= count); // check for overflow
    }

    function overflowmulocalonly(uint256 input) public {
        uint res = count * input;
        require(res / input == count); // check for overflow
    }

    function underflowlocalonly(uint256 input) public {
        uint res = count - input;
        require(res <= count); // check for underflow
    }
}