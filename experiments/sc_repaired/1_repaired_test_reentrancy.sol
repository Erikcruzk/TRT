/*
 * @source: https://ethernaut.zeppelin.solutions/level/0xf70706db003e94cfe4b5e27ffd891d5c81b39488
 * @author: Alejandro Santander
 * @fixed_at_lines: 16 - 17, 28
 */

pragma solidity ^0.4.18;

contract Reentrance {

  mapping(address => uint) public balances;

  function donate(address _to) public payable {
    balances[_to] += msg.value;
  }

  function balanceOf(address _who) public view returns (uint balance) {
    return balances[_who];
  }

  // <yes> <report> SAFETY_CHECK
  function withdraw(uint _amount) public {
    require(_amount <= balances[msg.sender], "Amount exceeds balance!");
    // <yes> <report> REENTRANCY
    if(msg.sender.call.value(_amount)()) {
      _amount;
    }
    // <yes> <report> BOUNDARY_CHECK
    balances[msg.sender] -= _amount;
  }

  function() public payable {}
}

