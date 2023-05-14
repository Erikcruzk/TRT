pragma solidity ^0.4.23;

contract IntegerOverflowMultiTxMultiFuncFeasible {
    uint256 private initialized = 0;
    uint256 public count = 1;

    function init() public {
        initialized = 1;
    }

    function run(uint256 input) public {
        require(initialized != 0, "Contract not initialized yet.");
        require(count >= input, "Input value exceeds count.");

        count -= input;
    }
}