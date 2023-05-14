pragma solidity ^0.4.23;

contract IntegerOverflowSingleTransaction {
    uint public count = 1;

    function overflowaddtostate(uint256 input) public {
        require(count + input >= count);
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

    function overflowlocalonly(uint256 input) public pure returns (uint) {
        uint res = 0;
        if (input != 0) {
            res = 1 + input;
        }
        return res;
    }

    function overflowmulocalonly(uint256 input) public pure returns (uint) {
        uint res = 0;
        if (input != 0) {
            res = 1 * input;
        }
        return res;
    }

    function underflowlocalonly(uint256 input) public pure returns (uint) {
        uint res = 1;
        if (input != 0) {
            res = 1 - input;
        }
        return res;
    }
}