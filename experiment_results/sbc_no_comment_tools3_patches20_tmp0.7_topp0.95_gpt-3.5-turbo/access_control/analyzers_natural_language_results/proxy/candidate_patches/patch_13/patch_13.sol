pragma solidity ^0.4.24;

contract Proxy {
    address public owner;

    constructor() public {
        owner = msg.sender;
    }

    function forward(address _callee, bytes memory _data) public returns(bool) {
        (bool success, ) = _callee.delegatecall(_data);
        require(success);
        return true;
    }
}