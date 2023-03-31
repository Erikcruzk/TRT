/*
 * @source: https://ethernaut.zeppelin.solutions/level/0xf70706db003e94cfe4b5e27ffd891d5c81b39488
 * @author: Alejandro Santander
 * @fixed_by: [Your Name]
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
    if(balances[msg.sender] >= _amount && !locked[msg.sender]) {
      locked[msg.sender] = true; // lock the sender's account before transferring funds
      balances[msg.sender] -= _amount;
      if(msg.sender.call.value(_amount)()) {
        _amount;
      }
      locked[msg.sender] = false; // unlock the sender's account after transferring funds
    }
  }

  function() public payable {}
}