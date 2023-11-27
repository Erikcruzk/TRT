pragma solidity ^0.4.25;

contract DosNumber {
uint constant MAX_ELEMENTS = 1500;
uint numElements = 0;
uint[] array;

address owner;

constructor() public {
owner = msg.sender;
}

function insertNnumbers(uint value, uint numbers) public {
require(numbers <= 100);
for(uint i=0; i<numbers; i++) {
if(numElements == array.length) {
array.length += 1;
}
array[numElements++] = value;
}
}

function clear() public {
require(msg.sender == owner);
numElements = 0;
}

function clearDOS() public {
require(msg.sender == owner);
array = new uint[](0);
numElements = 0;
}

function getLengthArray() public view returns(uint) {
return numElements;
}

function getRealLengthArray() public view returns(uint) {
return array.length;
}
}