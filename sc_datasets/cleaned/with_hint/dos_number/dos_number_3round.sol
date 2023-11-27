pragma solidity ^0.4.25;

contract DosNumber {

uint numElements = 0;
uint[] array;
uint lastClearTime = 0;
uint constant CLEAR_THRESHOLD = 1 days;
uint constant MAX_ARRAY_LENGTH = 10000;

function insertNnumbers(uint value, uint numbers) public {
require(array.length + numbers <= MAX_ARRAY_LENGTH);
for (uint i = 0; i < numbers; i++) {
if (numElements == array.length) {
array.length += 1;
}
array[numElements++] = value;
}
}

function clear() public {
require(numElements > 1500 && now > lastClearTime + CLEAR_THRESHOLD);
numElements = 0;
lastClearTime = now;
}

function clearDOS() public {
require(numElements > 1500);
array.length = 0;
numElements = 0;
lastClearTime = now;
}

function getLengthArray() public view returns (uint) {
return numElements;
}

function getRealLengthArray() public view returns (uint) {
return array.length;
}
}