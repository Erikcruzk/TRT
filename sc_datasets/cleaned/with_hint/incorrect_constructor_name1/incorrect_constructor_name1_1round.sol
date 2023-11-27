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

function () payable {}

function withdraw() public onlyowner {
require(owner.send(this.balance));
}
}