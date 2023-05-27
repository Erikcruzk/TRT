pragma solidity ^0.4.24;

contract Proxy {
    address owner;

    constructor() public {
        owner = msg.sender;
    }

    function forward(address callee, bytes _data) public {
        require(msg.sender == owner); // Added access control to only allow owner to call the function
        require(callee.call(_data)); // Changed delegatecall to call to prevent potential attacks
    }
}