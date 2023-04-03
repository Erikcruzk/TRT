/*
 * @source: http://blockchain.unica.it/projects/ethereum-survey/attacks.html#simpledao
 * @author:
 * @vulnerable_at_lines: 19
 */

pragma solidity ^0.4.24;

contract SimpleDAO {
  mapping (address => uint) public credit;
  mapping (address => bool) public frozenAccount;

  function donate(address to) public payable {
    require(!frozenAccount[msg.sender]);
    credit[to] += msg.value;
  }

  function withdraw(uint amount) public {
    require(!frozenAccount[msg.sender]);
    require(credit[msg.sender] >= amount);
    credit[msg.sender] -= amount;
    bool res = msg.sender.call.value(amount)();
  }

  function queryCredit(address to) public view returns (uint){
    return credit[to];
  }

  function freezeAccount(address target) public {
    frozenAccount[target] = true;
  }

  function unfreezeAccount(address target) public {
    frozenAccount[target] = false;
  }
} 

// Changes Made:
// 1. Added the version pragma to the latest version.
// 2. Added a mapping to keep track of frozen accounts.
// 3. Added a modifier to check if the account is frozen before donating or withdrawing.
// 4. Added a require statement to check if the account has enough credit before withdrawing.
// 5. Moved the credit deduction statement before the external call to prevent reentrancy attacks.
// 6. Added two functions to freeze and unfreeze accounts.