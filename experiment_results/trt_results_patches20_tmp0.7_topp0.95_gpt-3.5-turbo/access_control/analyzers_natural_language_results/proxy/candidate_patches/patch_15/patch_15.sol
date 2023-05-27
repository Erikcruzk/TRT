pragma solidity ^0.4.24;

contract Proxy {
    address owner;

    constructor() public {
        owner = msg.sender;
    }

    function forward(address callee, bytes _data) public {
        require(msg.sender == owner); // add access control to ensure only the contract owner can call the function
        require(callee.call(_data)); // use call instead of delegatecall to prevent potential security vulnerabilities
    }
}