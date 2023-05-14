pragma solidity ^0.4.24;

contract Proxy {
    address private owner;

    constructor() public {
        owner = msg.sender;
    }

    function forward(address _callee, bytes memory _data) public {
        require(msg.sender == owner);
        (bool success, ) = _callee.delegatecall(_data);
        require(success);
    }
}