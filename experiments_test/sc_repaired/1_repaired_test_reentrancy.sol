/*
 * Fix the following vulnerabilities:
 * - Reentrancy:
 *   The function `withdraw` calls `msg.sender.call.value(_amount)()` to send
 *   ether to an address that is the same as the address calling the function.
 *   Therefore, the called address could be a malicious smart contract that
 *   exploits the `withdraw` function multiple times. For example, a malicious
 *   contract could receive 100 ETH and make 5 calls of 20 ETH. The state of
 *   the balance of the malicious contract is updated after each call, but the
 *   other state variables (e.g., totalBalance) are updated only at the end of
 *   the execution of the function.
 *
 *   The function `withdraw` could use a mutex to not allow multiple concurrent
 *   calls. For example, it could define a mutex boolean variable, initialized
 *   to false. When the function is called, it first checks if the mutex
 *   variable is true and does nothing if that's the case. Otherwise, it updates
 *   the state of all variables and sets the mutex to true. Once it has
 *   finished the execution, it sets the mutex to false.
 */

pragma solidity ^0.4.18;

contract Reentrance {

  bool locked = false;
  mapping(address => uint) public balances;

  function donate(address _to) public payable {
    balances[_to] += msg.value;
  }

  function balanceOf(address _who) public view returns (uint balance) {
    return balances[_who];
  }

  function withdraw(uint _amount) public {
    if(balances[msg.sender] >= _amount) {
      if (!locked) {
        balances[msg.sender] -= _amount;
        locked = true;
        if(msg.sender.call.value(_amount)()) {
          _amount;
        }
        locked = false;
      }
    }
  }

  function() public payable {}
}

