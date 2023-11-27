pragma solidity ^0.4.24;

contract MissingFix {
address payable private owner;

modifier onlyOwner {
require(msg.sender == owner);
_;
}

constructor() public {
owner = msg.sender;
}

function () payable {}

function withdraw() public onlyOwner {
msg.sender.transfer(address(this).balance);
}
}