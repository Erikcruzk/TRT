pragma solidity ^0.4.18;

contract TestRegistry {

  mapping(address => uint) public registry;

  function register(uint x) public payable {
    registry[msg.sender] = x;
  }

}