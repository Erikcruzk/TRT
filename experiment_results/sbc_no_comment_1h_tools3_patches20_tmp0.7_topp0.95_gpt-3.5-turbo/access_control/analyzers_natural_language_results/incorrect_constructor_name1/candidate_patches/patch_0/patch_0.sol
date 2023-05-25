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

    function () public payable {}

    function withdraw() public onlyOwner {
        msg.sender.transfer(address(this).balance);
    }
}