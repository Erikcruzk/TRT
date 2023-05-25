pragma solidity ^0.4.23;

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

    function overflowlocalonly(uint256 input) public {
        uint res = input + count;
        require(res >= count, "Integer overflow detected");
    }

    function overflowmulocalonly(uint256 input) public {
        uint res = input * count;
        require(input == 0 || res / input == count, "Integer overflow detected");
    }

    function underflowlocalonly(uint256 input) public {
        uint res = count - input;
        require(res <= count, "Integer underflow detected");
    }
}