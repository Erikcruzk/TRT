pragma solidity ^0.4.23;

contract IntegerOverflowMultiTxOneFuncFeasible {
    uint256 private initialized = 0;
    uint256 public count = 1;

    function run(uint256 input) public {
        require(initialized > 0, "Initialization not yet done");
        require(count > input, "Input exceeds count");

        count -= input;
    }

    function initialize() public {
        require(initialized == 0, "Already initialized");
        initialized = 1;
    }
}