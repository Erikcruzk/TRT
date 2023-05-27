pragma solidity ^0.4.24;

contract Proxy {
    address owner;

    constructor() public {
        owner = msg.sender;
    }

    function forward(address callee, bytes _data) public onlyOwner {
        require(callee.call(_data));
    }
    
    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }
}