pragma solidity ^0.4.23;

contract IntegerOverflowSingleTransaction {
    uint public count = 1;

    function overflowaddtostate(uint256 input) public {
        require(input + count > count);
        count += input;
    }

    function overflowmultostate(uint256 input) public {
        require(input == 0 || count * input / input == count);
        count *= input;
    }

    function underflowtostate(uint256 input) public {
        require(input <= count);
        count -= input;
    }

    function overflowlocalonly(uint256 input) public {
        uint res = input + count;
        require(res >= count);
    }

    function overflowmulocalonly(uint256 input) public {
        uint res = input * count;
        require(res >= count);
    }

    function underflowlocalonly(uint256 input) public {
        uint res = count - input;
        require(res <= count);
    }
}