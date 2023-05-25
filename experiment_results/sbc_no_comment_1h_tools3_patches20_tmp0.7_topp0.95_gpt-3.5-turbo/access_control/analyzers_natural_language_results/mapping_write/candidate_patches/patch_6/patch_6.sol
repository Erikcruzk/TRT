pragma solidity ^0.4.24;

contract Map {
    address public owner;
    mapping (uint256 => uint256) map; // Changed map from an array to a mapping

    constructor() public {
        owner = msg.sender; // Set owner to the contract creator
    }

    function set(uint256 key, uint256 value) public {
        require(msg.sender == owner); // Only owner can set values
        map[key] = value;
    }

    function get(uint256 key) public view returns (uint256) {
        return map[key];
    }

    function withdraw() public {
        require(msg.sender == owner);
        msg.sender.transfer(address(this).balance);
    }
}