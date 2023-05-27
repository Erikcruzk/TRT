pragma solidity ^0.8.0;

contract Map {
    address payable public owner;
    mapping(uint256 => uint256) map;

    constructor() {
        owner = payable(msg.sender);
    }

    function set(uint256 key, uint256 value) public {
        map[key] = value;
    }

    function get(uint256 key) public view returns (uint256) {
        return map[key];
    }

    function withdraw() public {
        require(msg.sender == owner, "Only owner can withdraw");
        uint256 balance = address(this).balance;
        require(balance > 0, "No balance to withdraw");
        owner.transfer(balance);
    }
}