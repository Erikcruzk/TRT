pragma solidity ^0.4.23;

contract IntegerOverflowMultiTxOneFuncFeasible {
    uint256 private initialized = 0;
    uint256 public count = 1;

    function run(uint256 input) public {
        require(initialized > 0, "Contract not initialized");
        require(input <= count, "Input value must be less than or equal to count");
        count -= input;
    }
}