pragma solidity ^0.4.23;

contract IntegerOverflowSingleTransaction {
    uint256 public count = 1;

    function overflowAddToState(uint256 input) public {
        require(count + input > count, "Integer overflow detected");
        count += input;
    }

    function overflowMulToState(uint256 input) public {
        require(count * input > count, "Integer overflow detected");
        count *= input;
    }

    function underflowToState(uint256 input) public {
        require(count >= input, "Integer underflow detected");
        count -= input;
    }

    function overflowLocalOnly(uint256 input) public view returns (uint256) {
        return count + input;
    }

    function overflowMulLocalOnly(uint256 input) public view returns (uint256) {
        return count * input;
    }

    function underflowLocalOnly(uint256 input) public view returns (uint256) {
        return count - input;
    }
}