pragma solidity ^0.4.23;

contract IntegerOverflowMultiTxOneFuncFeasible {
    uint256 private initialized = 0;
    uint256 public count = 1;

    function run(uint256 input) public {
        require(count > input, "Subtraction result cannot be negative");
        if (initialized == 0) {
            initialized = 1;
            return;
        }

        count -= input;
    }
}