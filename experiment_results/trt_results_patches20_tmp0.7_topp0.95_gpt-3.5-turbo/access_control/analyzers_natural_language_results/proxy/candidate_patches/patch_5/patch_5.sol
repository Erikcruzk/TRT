pragma solidity ^0.4.24;

contract Proxy {
    address owner;

    constructor() public {
        owner = msg.sender;
    }

    function forward(address _callee, bytes _data) public {
        require(_callee != address(0)); // Check if callee address is not null
        require(msg.sender == owner); // Only owner can forward the call
        require(_callee.call(_data)); // Use call instead of delegatecall
    }
}