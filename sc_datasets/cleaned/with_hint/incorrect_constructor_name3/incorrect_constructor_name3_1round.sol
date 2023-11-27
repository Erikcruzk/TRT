pragma solidity ^0.4.24;

contract Missing{
address private owner;

modifier onlyowner {
require(msg.sender==owner);
_;
}

constructor() public payable {
owner = msg.sender;
}

function () public payable {}

function withdraw() public payable onlyowner {
msg.sender.transfer(address(this).balance);
}
}