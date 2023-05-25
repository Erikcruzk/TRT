pragma solidity ^0.4.23;

contract IntegerOverflowSingleTransaction {
    uint public count = 1;

    function overflowaddtostate(uint256 input) public {
        require(input + count > count); // prevent overflow
        count += input;
    }

    function overflowmultostate(uint256 input) public {
        require(input == 0 || count * input / input == count); // prevent overflow
        count *= input;
    }

    function underflowtostate(uint256 input) public {
        require(input <= count); // prevent underflow
        count -= input;
    }

    function overflowlocalonly(uint256 input) public {
        uint res = count + input;
        require(res >= count); // prevent overflow
    }

    function overflowmulocalonly(uint256 input) public {
        uint res = count * input;
        require(res / input == count); // prevent overflow
    }

    function underflowlocalonly(uint256 input) public {
        uint res = count - input;
        require(res <= count); // prevent underflow
    }
}