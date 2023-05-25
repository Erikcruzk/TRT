pragma solidity ^0.4.10;

contract Caller {
    function callAddress(address a) {
        require(a.call()); // add require statement to check return value of call()
    }
}