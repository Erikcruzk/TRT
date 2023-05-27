pragma solidity ^0.4.24;

contract Proxy {
    address owner;

    constructor() public {
        owner = msg.sender;
    }

    function forward(address _callee, bytes _data) public {
        require(msg.sender == owner);
        require(_callee.delegatecall(_data));
    }
}