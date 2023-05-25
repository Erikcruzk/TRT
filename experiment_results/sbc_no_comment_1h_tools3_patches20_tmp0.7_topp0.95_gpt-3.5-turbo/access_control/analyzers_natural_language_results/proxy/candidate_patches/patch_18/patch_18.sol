pragma solidity ^0.4.24;

contract Proxy {
    address owner;

    constructor() public {
        owner = msg.sender;
    }

    function forward(address callee, bytes memory _data) public {
        (bool success, ) = callee.delegatecall(_data);
        require(success);
    }
}