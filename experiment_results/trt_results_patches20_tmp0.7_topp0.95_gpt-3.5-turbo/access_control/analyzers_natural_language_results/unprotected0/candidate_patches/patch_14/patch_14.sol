pragma solidity ^0.4.15;

contract Protected {
    address private owner;

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    constructor() public {
        owner = msg.sender;
    }

    function changeOwner(address newOwner) public onlyOwner {
        owner = newOwner;
    }
}