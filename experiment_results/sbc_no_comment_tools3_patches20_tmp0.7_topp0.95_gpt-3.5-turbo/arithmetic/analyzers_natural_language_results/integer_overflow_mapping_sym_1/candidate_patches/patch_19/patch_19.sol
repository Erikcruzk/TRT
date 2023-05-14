pragma solidity ^0.4.11;

contract IntegerOverflowMappingSym1 {
    mapping(uint256 => uint256) map;

    function init(uint256 k, uint256 v) public {
        require(map[k] >= v); // Add a require statement to check if subtraction will not result in an underflow
        map[k] -= v;
    }
}