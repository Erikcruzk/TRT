pragma solidity ^0.4.25;

contract DosOneFunc {

address[] listAddresses;

function ifillArray() public returns (bool){
if(listAddresses.length<1500) {
uint256 remaining = 1500 - listAddresses.length;
uint256 toAdd = remaining < 350 ? remaining : 350;
for(uint i=0;i<toAdd;i++) {
listAddresses.push(msg.sender);
}
return true;
} else {
delete listAddresses;
return false;
}
}
}