pragma solidity ^0.4.11;

contract IntegerOverflowMappingSym1 {
    mapping(uint256 => uint256) map;

    function init(uint256 k, uint256 v) public {
        require(v <= map[k]); // check if v is less than or equal to the value stored in the mapping
        map[k] -= v;
    }
}