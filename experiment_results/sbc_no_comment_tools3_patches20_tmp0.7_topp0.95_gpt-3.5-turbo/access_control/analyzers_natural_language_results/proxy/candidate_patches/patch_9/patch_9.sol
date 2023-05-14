pragma solidity ^0.4.24;

contract Proxy {
    address public owner;

    constructor() public {
        owner = msg.sender;
    }

    function forward(address _callee, bytes _data) public {
        require(_callee.delegatecall(_data));
    }
}