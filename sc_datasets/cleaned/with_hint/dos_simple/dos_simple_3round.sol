pragma solidity ^0.4.25;

contract DosOneFunc {

address[] listAddresses;
uint256 public counter;

function ifillArray() public returns (bool) {
if (listAddresses.length < 1500 && counter < 10) {
for (uint i = 0; i < 350; i++) {
listAddresses.push(msg.sender);
}
counter++;
return true;
} else {
listAddresses = new address[](0);
counter = 0;
return false;
}
}
}