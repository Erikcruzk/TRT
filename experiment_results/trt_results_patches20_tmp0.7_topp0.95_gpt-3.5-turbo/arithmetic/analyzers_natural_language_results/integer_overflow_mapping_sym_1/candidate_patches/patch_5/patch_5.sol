pragma solidity ^0.4.11;

contract IntegerOverflowMappingSym1 {
    mapping(uint256 => int256) map;

    function init(uint256 k, uint256 v) public {
        require(v <= 2**255); // Check for potential integer overflow
        map[k] -= int256(v);
    }
}