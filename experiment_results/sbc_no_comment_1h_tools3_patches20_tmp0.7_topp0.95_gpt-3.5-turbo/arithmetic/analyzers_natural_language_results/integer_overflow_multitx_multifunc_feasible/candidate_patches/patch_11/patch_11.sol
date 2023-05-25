pragma solidity ^0.4.23;

contract IntegerOverflowMultiTxMultiFuncFeasible {
    uint256 private initialized = 0;
    uint256 public count = 1;

    function init() public {
        initialized = 1;
    }

    function run(uint256 input) public {
        require(initialized == 1); // Check if the contract has been initialized
        
        require(input <= count); // Check if input is not greater than current count value
        
        count -= input;
    }
}