pragma solidity ^0.4.25;

contract DosGas {

address[] creditorAddresses;
bool win = false;

function emptyCreditors() public {
require(creditorAddresses.length > 1500, "Not enough creditors to empty");
delete creditorAddresses;
win = true;
}

function addCreditors() public returns (bool) {
for(uint i=0; i<350; i++) {
creditorAddresses.push(msg.sender);
}
return true;
}

function iWin() public view returns (bool) {
return win;
}

function numberCreditors() public view returns (uint) {
return creditorAddresses.length;
}
}