pragma solidity ^0.4.24;

contract IamMissing {
address private owner;

modifier onlyowner {
require(msg.sender == owner);
_;
}

constructor() public {
owner = msg.sender;
}

function () payable public {}

function withdraw() public onlyowner {
owner.transfer(address(this).balance);
}
}