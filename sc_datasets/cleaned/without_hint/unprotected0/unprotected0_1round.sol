pragma solidity ^0.4.15;

contract Protected{
address private owner;

modifier onlyOwner {
require(msg.sender == owner);
_;
}

function Protected() public {
owner = msg.sender;
}

function changeOwner(address _newOwner) public onlyOwner {
require(_newOwner != address(0));
owner = _newOwner;
}

function getOwner() public view returns (address) {
return owner;
}
}