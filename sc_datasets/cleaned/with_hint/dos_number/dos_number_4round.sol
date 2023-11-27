pragma solidity ^0.4.25;

contract DosNumber {

uint constant MAX_ELEMENTS = 1000;
uint constant MAX_CLEAR_ELEMENTS = 1500;

uint numElements = 0;
uint[] array;

function insertNnumbers(uint value, uint numbers) public {
require(numbers <= MAX_ELEMENTS);
for (uint i = 0; i < numbers; i++) {
if (numElements == array.length) {
array.length += 1;
}
array[numElements++] = value;
}
}

function clear() public {
require(numElements > MAX_CLEAR_ELEMENTS);
numElements = 0;
}

function clearDOS() public {
require(numElements > MAX_CLEAR_ELEMENTS);
delete array;
numElements = 0;
}

function getLengthArray() public view returns (uint) {
return numElements;
}

function getRealLengthArray() public view returns (uint) {
return array.length;
}
}