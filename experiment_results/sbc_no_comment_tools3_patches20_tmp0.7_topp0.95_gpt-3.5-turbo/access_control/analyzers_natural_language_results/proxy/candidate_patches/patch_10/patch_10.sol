pragma solidity ^0.4.24;

contract Proxy {
    address private owner;

    constructor() public {
        owner = msg.sender;
    }

    function forward(address _callee, bytes memory _data) public {
        require(_callee.delegatecall(_data));
    }
}