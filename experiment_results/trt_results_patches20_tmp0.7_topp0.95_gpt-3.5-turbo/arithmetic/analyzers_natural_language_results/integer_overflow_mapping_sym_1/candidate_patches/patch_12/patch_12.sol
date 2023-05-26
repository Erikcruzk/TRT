pragma solidity ^0.4.11;

contract IntegerOverflowMappingSym1 {
    mapping(uint256 => int256) map;

    function init(uint256 k, int256 v) public {
        map[k] -= v;
    }
}