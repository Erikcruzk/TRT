pragma solidity ^0.4.15;

contract Protected {
    address private owner;

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    function Protected() public {
        owner = msg.sender;
    }

    function changeOwner(address newOwner) public onlyOwner {
        require(newOwner != address(0));
        owner = newOwner;
    }
}