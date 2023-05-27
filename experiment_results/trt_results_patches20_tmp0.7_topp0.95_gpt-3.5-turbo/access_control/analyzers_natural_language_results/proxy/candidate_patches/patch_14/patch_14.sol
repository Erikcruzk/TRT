pragma solidity ^0.4.24;

contract Proxy {
    address owner;

    constructor() public {
        owner = msg.sender;
    }

    function forward(address callee, bytes _data) public {
        require(msg.sender == owner); // Check if the sender is the owner of the contract
        require(callee.call(_data)); // Use call instead of delegatecall to prevent execution of arbitrary code
    }
}