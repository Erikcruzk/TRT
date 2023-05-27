pragma solidity ^0.4.24;

contract FixedMissing {
    address private owner;

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    constructor() public {
        owner = msg.sender;
    }

    function () public payable {}

    function withdraw() public onlyOwner {
        owner.transfer(address(this).balance);
    }
}