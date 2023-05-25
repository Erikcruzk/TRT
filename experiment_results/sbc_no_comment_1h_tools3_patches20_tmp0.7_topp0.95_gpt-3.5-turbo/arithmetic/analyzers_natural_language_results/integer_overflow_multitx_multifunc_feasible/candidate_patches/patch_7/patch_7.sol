pragma solidity ^0.4.23;

contract IntegerOverflowMultiTxMultiFuncFeasible {
    uint256 private initialized = 0;
    uint256 public count = 1;

    function init() public {
        require(initialized == 0); // make sure init is called only once
        initialized = 1;
    }

    function run(uint256 input) public {
        require(initialized == 1); // make sure init has been called
        require(count >= input); // check for underflow
        count -= input;
    }
}