pragma solidity ^0.4.24;

contract Proxy {
    address owner;

    constructor() public {
        owner = msg.sender;
    }

    function forward(address callee, bytes _data) public {
        require(msg.sender == owner); // adding access control
        require(callee.call(_data)); // replacing delegatecall with call
    }
}