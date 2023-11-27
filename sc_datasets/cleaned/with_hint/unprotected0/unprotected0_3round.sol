pragma solidity ^0.4.15;

contract Protected{
address private owner;

modifier onlyowner {
require(msg.sender==owner);
_;
}

function Protected() public {
owner = msg.sender;
}

function changeOwner(address _newOwner) public onlyowner {
owner = _newOwner;
}
}