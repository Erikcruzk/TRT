pragma solidity ^0.4.10;

contract Caller {
    function callAddress(address a) {
        require(a.call()); // Check the return value of the call
    }
}