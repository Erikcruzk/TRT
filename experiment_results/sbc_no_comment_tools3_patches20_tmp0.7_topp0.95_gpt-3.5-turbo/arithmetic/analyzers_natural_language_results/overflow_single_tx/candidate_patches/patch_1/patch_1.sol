pragma solidity ^0.4.23;

contract IntegerOverflowSingleTransaction {
    uint public count = 1;

    function overflowaddtostate(uint256 input) public {
        require(count + input >= count); // prevent integer overflow
        count += input;
    }

    function overflowmultostate(uint256 input) public {
        require(input == 0 || count * input / input == count); // prevent integer overflow
        count *= input;
    }

    function underflowtostate(uint256 input) public {
        require(count >= input); // prevent integer underflow
        count -= input;
    }

    function overflowlocalonly(uint256 input) public pure returns (uint) {
        uint res = 0;
        require(uint(-1) - input >= res); // prevent integer overflow in local variable
        res = count + input;
        return res;
    }

    function overflowmulocalonly(uint256 input) public pure returns (uint) {
        uint res = 0;
        require(input == 0 || uint(-1) / input >= count); // prevent integer overflow in local variable
        res = count * input;
        return res;
    }

    function underflowlocalonly(uint256 input) public pure returns (uint) {
        uint res = 0;
        require(count >= input); // prevent integer underflow in local variable
        res = count - input;
        return res;
    }
}