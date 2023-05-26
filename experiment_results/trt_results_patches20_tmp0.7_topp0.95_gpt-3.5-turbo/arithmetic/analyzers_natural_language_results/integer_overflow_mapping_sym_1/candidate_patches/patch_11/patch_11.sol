pragma solidity ^0.4.11;

contract IntegerOverflowMappingSym1 {
    mapping(uint256 => uint256) map;

    function init(uint256 k, uint256 v) public {
        require(v <= map[k]); // check if v is not greater than the value stored in map[k]
        map[k] -= v;
    }
}