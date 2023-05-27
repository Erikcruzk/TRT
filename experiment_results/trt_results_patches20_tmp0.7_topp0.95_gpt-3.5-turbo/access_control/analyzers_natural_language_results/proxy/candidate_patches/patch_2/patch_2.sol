pragma solidity ^0.4.24;

contract Proxy {
    address owner;

    constructor() public {
        owner = msg.sender;
    }

    function forward(address callee, bytes _data) public {
        require(msg.sender == owner); // add access control to only allow owner to forward
        require(callee.call(_data)); // use call instead of delegatecall to prevent possible attacks
    }
}