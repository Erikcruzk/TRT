/*
 * @source: https://ethernaut.zeppelin.solutions/level/0xf70706db003e94cfe4b5e27ffd891d5c81b39488
 * @author: Alejandro Santander
 * @fixed_by: [your name here]
 * @vulnerable_at_lines: 24
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
    require(!locked[msg.sender]); // prevent reentrancy
    require(balances[msg.sender] >= _amount);
    locked[msg.sender] = true; // lock the user's account
    balances[msg.sender] -= _amount;
    msg.sender.transfer(_amount); // send the funds after updating balances
    locked[msg.sender] = false; // unlock the user's account
  }

  function() public payable {}
}