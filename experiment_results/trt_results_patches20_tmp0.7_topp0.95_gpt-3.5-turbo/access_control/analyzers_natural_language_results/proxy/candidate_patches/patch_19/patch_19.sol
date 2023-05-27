pragma solidity ^0.4.24;

contract Proxy {
    address owner;

    constructor() public {
        owner = msg.sender;
    }

    function forward(address callee, bytes _data) public {
        require(msg.sender == owner); // Only the owner can call this function
        require(callee.call(_data)); // Use "call" instead of "delegatecall"
    }
}