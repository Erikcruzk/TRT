pragma solidity ^0.4.24;

contract Proxy {
    address owner;

    constructor() public {
        owner = msg.sender;
    }

    function forward(address callee, bytes memory _data) public {
        require(address(callee).delegatecall(_data));
    }
}