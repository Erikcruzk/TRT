pragma solidity ^0.8.0;

contract Missing {
    address payable private owner;

    modifier onlyOwner() {
        require(msg.sender == owner, "Only contract owner can call this function.");
        _;
    }

    constructor() {
        owner = payable(msg.sender);
    }

    receive() external payable {}

    function withdraw() public onlyOwner {
        uint balance = address(this).balance;
        owner.transfer(balance);
    }
}