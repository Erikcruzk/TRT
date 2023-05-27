pragma solidity ^0.4.10;

contract Caller {
    function callAddress(address a) {
        require(a.call()); // added require statement to check if the call was successful
    }
}