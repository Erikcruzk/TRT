pragma solidity ^0.4.24;

contract Proxy {

address owner;

constructor() public {
owner = msg.sender;
}

function forward(address callee, bytes _data) public {
require(isContract(callee));
require(callee.call(_data));
}

function isContract(address _addr) private view returns (bool) {
uint256 size;
assembly { size := extcodesize(_addr) }
return size > 0;
}
}