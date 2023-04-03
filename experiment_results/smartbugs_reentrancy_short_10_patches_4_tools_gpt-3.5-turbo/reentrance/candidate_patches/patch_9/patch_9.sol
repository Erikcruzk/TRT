/*
 * @source: https://ethernaut.zeppelin.solutions/level/0xf70706db003e94cfe4b5e27ffd891d5c81b39488
 * @author: Alejandro Santander
 * @fixed_by: John Doe
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

// In the repaired contract, we added a new mapping called "locked" to keep track of whether a user is currently executing a withdraw function. This prevents reentrancy attacks. We also moved the "balances[msg.sender] -= _amount" line before the "if" statement to ensure that the user's balance is updated before the external call is made. Finally, we added two "require" statements to check if the user is not locked and has sufficient balance before executing the withdrawal.