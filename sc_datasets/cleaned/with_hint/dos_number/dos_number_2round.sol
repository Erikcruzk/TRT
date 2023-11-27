pragma solidity ^0.4.25;

contract DosNumber {

uint numElements = 0;
uint[] array;
uint lastClearTime = 0;

function insertNnumbers(uint value, uint numbers) public {
require(numbers <= 100); 
for (uint i = 0; i < numbers; i++) {
if (numElements == array.length) {
array.length += 1;
}
array[numElements++] = value;
}
}

function clear() public {
require(numElements > 1500 && now > lastClearTime + 1 days); 
numElements = 0;
lastClearTime = now;
}

function clearDOS() public {
require(numElements > 1500);
array = new uint[](0);
numElements = 0;
}

function getLengthArray() public view returns (uint) {
return numElements;
}

function getRealLengthArray() public view returns (uint) {
return array.length;
}
}