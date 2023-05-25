pragma solidity ^0.4.23;

contract IntegerOverflowMultiTxMultiFuncFeasible {
    uint256 private initialized = 0;
    uint256 public count = 1;

    function init() public {
        require(initialized == 0, "Contract already initialized");
        initialized = 1;
    }

    function run(uint256 input) public {
        require(initialized == 1, "Contract not initialized");
        require(input <= count, "Input must be less than or equal to count");
        count -= input;
    }
}