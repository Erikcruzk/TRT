pragma solidity ^0.4.23;

contract IntegerOverflowMultiTxOneFuncFeasible {
    uint256 private initialized = 0;
    uint256 public count = 1;

    function run(uint256 input) public {
        require(initialized == 1, "Contract not initialized yet");
        require(count >= input, "Input is greater than count");
        count -= input;
    }

    function initialize() public {
        require(initialized == 0, "Contract already initialized");
        initialized = 1;
    }
}