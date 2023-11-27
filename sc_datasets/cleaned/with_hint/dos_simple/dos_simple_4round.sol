pragma solidity ^0.4.25;

contract DosOneFunc {
address[] listAddresses;
address owner;

constructor() public {
owner = msg.sender;
}

function ifillArray() public returns (bool) {
require(msg.sender == owner, "Only the contract owner can call this function.");

if (listAddresses.length < 1500) {
for (uint i = 0; i < 350; i++) {
listAddresses.push(msg.sender);
}
return true;
} else {
listAddresses = new address[](0);
return false;
}
}
}