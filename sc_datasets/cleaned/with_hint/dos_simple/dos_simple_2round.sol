pragma solidity ^0.4.25;

contract DosOneFunc {

address[] listAddresses;

function ifillArray() public returns (bool) {
if (listAddresses.length < 1500) {
for (uint i = 0; i < 350; i++) {
if (listAddresses.length >= 1500) {
break;
}
if (listAddresses[i] != msg.sender) {
listAddresses.push(msg.sender);
}
}
return true;
} else {
listAddresses = new address[](0);
return false;
}
}
}