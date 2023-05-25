pragma solidity ^0.4.23;

contract IntegerOverflowMultiTxOneFuncFeasible {
    uint256 private initialized = 0;
    uint256 public count = 1;

    function run(uint256 input) public {
        require(initialized > 0, "Contract not initialized.");
        
        if(count > input){
            count -= input;
        }
        else{
            count = 0;
        }
        
        initialized = 1;
    }
}