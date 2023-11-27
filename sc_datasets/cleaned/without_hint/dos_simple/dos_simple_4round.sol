pragma solidity ^0.4.25;

contract DosOneFunc {

address[] listAddresses;

function ifillArray() public returns (bool){
require(listAddresses.length < 1500, "Array is already full");
for(uint i=0; i<350; i++) {
listAddresses.push(msg.sender);
}
return true;
}

function clearArray() public {
require(listAddresses.length >= 1500, "Array is not full yet");
delete listAddresses;
}
}