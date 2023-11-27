pragma solidity ^0.4.24;

contract Missing is Owned {
constructor() public {
owner = msg.sender;
}

function () payable {}

function withdraw() public onlyOwner {
msg.sender.transfer(address(this).balance);
}
}