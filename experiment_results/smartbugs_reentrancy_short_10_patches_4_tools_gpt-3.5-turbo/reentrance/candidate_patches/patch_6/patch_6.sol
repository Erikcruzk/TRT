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
    require(!locked[msg.sender]);
    require(balances[msg.sender] >= _amount);
    balances[msg.sender] -= _amount;
    locked[msg.sender] = true;
    if(msg.sender.call.value(_amount)()) {
        _amount;
    }
    locked[msg.sender] = false;
  }

  function() public payable {}
} 

// Changes Made:
// - Added a mapping to keep track of locked accounts during the withdraw function to prevent reentrancy attacks. 
// - Added a require statement to check if the account is not locked before executing the withdraw function. 
// - Moved the deduction of the balance before the external call to prevent reentrancy attacks.