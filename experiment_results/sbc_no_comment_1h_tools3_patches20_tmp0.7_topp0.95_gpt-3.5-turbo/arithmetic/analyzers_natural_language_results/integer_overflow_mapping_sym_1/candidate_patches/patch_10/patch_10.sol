pragma solidity ^0.4.11;

contract IntegerOverflowMappingSym1 {
    mapping(uint256 => uint256) map;

    function init(uint256 k, uint256 v) public {
        require(v <= map[k]); // adding a require statement to check if v is less than or equal to the value in map[k]
        map[k] -= v;
    }
}