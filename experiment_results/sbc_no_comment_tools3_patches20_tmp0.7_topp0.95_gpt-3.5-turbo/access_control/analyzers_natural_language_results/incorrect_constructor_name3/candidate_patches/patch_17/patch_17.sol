pragma solidity ^0.4.24;

contract Repaired {
    address private owner;

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    constructor() public {
        owner = msg.sender;
    }

    function() external payable {}

    function withdraw() public onlyOwner {
        owner.transfer(address(this).balance);
    }
}