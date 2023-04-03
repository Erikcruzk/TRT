/*
 * @source: https://ethernaut.zeppelin.solutions/level/0xf70706db003e94cfe4b5e27ffd891d5c81b39488
 * @author: Alejandro Santander
 */

pragma solidity ^0.4.18;

contract Reentrance {

  mapping(address => uint) public balances;
  mapping(address => bool) public locked;

  function donate(address _to) public payable {
    balances[_to] += msg.value;
  }

  function balanceOf(address _who) public view returns (uint balance) {
    return balances[_who];
  }

  function withdraw(uint _amount) public {
    require(!locked[msg.sender]);
    require(balances[msg.sender] >= _amount);
    balances[msg.sender] -= _amount;
    locked[msg.sender] = true;
    msg.sender.transfer(_amount);
    locked[msg.sender] = false;
  }

  function() public payable {}
} 

// Changes Made:
// 1. Added a mapping to keep track of locked accounts to prevent reentrancy attacks.
// 2. Replaced the external call with transfer() function to prevent reentrancy attacks.
// 3. Added require() statements to check for locked accounts and sufficient balance before withdrawing.