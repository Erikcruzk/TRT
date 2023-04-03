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
    require(!locked[msg.sender]);
    require(balances[msg.sender] >= _amount);
    locked[msg.sender] = true;
    balances[msg.sender] -= _amount;
    msg.sender.transfer(_amount);
    locked[msg.sender] = false;
  }

  function() public payable {}
} 

// Changes Made:
// - Added a 'locked' mapping to prevent reentrancy attacks
// - Changed the 'if' statement to a 'require' statement in the 'withdraw' function for better readability and security
// - Replaced the 'call' function with 'transfer' to prevent reentrancy attacks