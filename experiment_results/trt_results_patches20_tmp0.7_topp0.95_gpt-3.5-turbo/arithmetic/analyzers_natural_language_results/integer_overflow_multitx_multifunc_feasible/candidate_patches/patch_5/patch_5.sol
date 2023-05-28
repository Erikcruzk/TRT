pragma solidity ^0.4.23;

contract IntegerOverflowMultiTxMultiFuncFeasible {
    uint256 private initialized = 0;
    uint256 public count = 1;

    function init() public {
        require(initialized == 0);
        initialized = 1;
    }

    function run(uint256 input) {
        require(input <= count);
        count -= input;
    }
}