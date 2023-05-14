pragma solidity ^0.8.0;

contract Map {
    address public owner;
    mapping(uint256 => uint256) map;

    constructor() {
        owner = msg.sender;
    }

    function set(uint256 key, uint256 value) public {
        map[key] = value;
    }

    function get(uint256 key) public view returns (uint256) {
        return map[key];
    }

    function withdraw() public {
        require(msg.sender == owner);
        payable(msg.sender).transfer(address(this).balance);
    }
}