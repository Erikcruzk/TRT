pragma solidity ^0.4.11;

contract IntegerOverflowMappingSym1 {
    mapping(uint256 => uint256) map;

    function init(uint256 k, uint256 v) public {
        require(map[k] >= v); // check if subtraction will not result in underflow
        map[k] -= v;
    }
}