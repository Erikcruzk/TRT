pragma solidity ^0.4.24;

contract Map {
    address public owner;
    mapping(uint256 => uint256) map; // changed from array to mapping

    constructor() public {
        owner = msg.sender; // set owner on contract creation
    }

    function set(uint256 key, uint256 value) public {
        require(msg.sender == owner); // only owner can set values
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