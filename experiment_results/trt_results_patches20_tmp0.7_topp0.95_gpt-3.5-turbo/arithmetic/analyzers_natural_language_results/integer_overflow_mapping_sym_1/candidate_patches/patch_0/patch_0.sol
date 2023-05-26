pragma solidity ^0.4.11;

contract IntegerOverflowMappingSym1 {
    mapping(uint256 => int256) map; // changed uint256 to int256 to allow negative values

    function init(uint256 k, uint256 v) public {
        require(v <= uint256(map[k])); // added a require statement to check if v is less than or equal to the current value in the map
        map[k] -= int256(v); // changed to subtract int256 value v from the map
    }
}