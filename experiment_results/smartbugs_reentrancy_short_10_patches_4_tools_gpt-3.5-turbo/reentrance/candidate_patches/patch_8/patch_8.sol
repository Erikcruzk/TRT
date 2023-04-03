/*
 * @source: https://ethernaut.zeppelin.solutions/level/0xf70706db003e94cfe4b5e27ffd891d5c81b39488
 * @author: Alejandro Santander
 * @fixed_by: John Doe
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
    require(!locked[msg.sender]); // Prevent reentrancy
    if(balances[msg.sender] >= _amount) {
      locked[msg.sender] = true;
      balances[msg.sender] -= _amount;
      if(msg.sender.call.value(_amount)()) {
        _amount;
      }
      locked[msg.sender] = false;
    }
  }

  function() public payable {}
}