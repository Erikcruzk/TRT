pragma solidity ^0.4.24;

contract Proxy {
    address public owner;

    constructor() public {
        owner = msg.sender;
    }

    function forward(address callee, bytes memory _data) public returns (bool success) {
        require(callee.delegatecall(_data));
        success = true;
    }
}