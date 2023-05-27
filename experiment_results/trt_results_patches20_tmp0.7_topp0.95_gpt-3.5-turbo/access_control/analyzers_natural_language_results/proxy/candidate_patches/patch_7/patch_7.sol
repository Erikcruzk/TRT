pragma solidity ^0.4.24;

contract Proxy {
    address owner;

    constructor() public {
        owner = msg.sender;
    }

    function forward(address callee, bytes _data) public returns (bool success) {
        require(msg.sender == owner);
        assembly {
            success := delegatecall(sub(gas, 10000), callee, add(_data, 0x20), mload(_data), 0, 0)
        }
        require(success);
    }
}