pragma solidity ^0.4.23;

contract IntegerOverflowMultiTxMultiFuncFeasible {
    uint256 private initialized = 0;
    uint256 public count = 1;

    function init() public {
        require(initialized == 0, "Already initialized");
        initialized = 1;
    }

    function run(uint256 input) public {
        require(initialized != 0, "Not initialized yet");
        require(count >= input, "Count is less than input");

        count -= input;
    }
}