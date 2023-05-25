pragma solidity ^0.8.0;

contract Fixed {
    address private owner;

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can perform this action.");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    receive() external payable {}

    function withdraw() external onlyOwner {
        payable(owner).transfer(address(this).balance);
    }
}