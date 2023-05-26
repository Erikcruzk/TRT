pragma solidity ^0.4.23;

contract IntegerOverflowMultiTxOneFuncFeasible {
    uint256 private initialized = 0;
    uint256 public count = 1;

    function run(uint256 input) public {
        require(initialized > 0); // only execute if contract is initialized
        require(count > input); // ensure subtraction does not result in underflow
        count -= input;
    }

    function initialize() public {
        require(initialized == 0); // only initialize once
        initialized = 1;
    }
}