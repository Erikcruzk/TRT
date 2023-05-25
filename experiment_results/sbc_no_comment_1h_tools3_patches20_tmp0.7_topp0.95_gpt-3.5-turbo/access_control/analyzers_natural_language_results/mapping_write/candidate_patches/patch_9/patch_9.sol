pragma solidity ^0.4.24;

contract Map {
    address public owner;
    mapping(uint256 => uint256) map;

    constructor() public {
        owner = msg.sender;
    }

    function set(uint256 key, uint256 value) public {
        require(msg.sender == owner);
        map[key] = value;
    }

    function get(uint256 key) public view returns (uint256) {
        return map[key];
    }

    function withdraw() public {
        require(msg.sender == owner);
        owner.transfer(address(this).balance);
    }
}