/*
 * @source: http://blockchain.unica.it/projects/ethereum-survey/attacks.html#simpledao
 * @author:
 * @vulnerable_at_lines: 19
 */

pragma solidity ^0.4.24;

contract SimpleDAO {
  mapping (address => uint) public credit;
  mapping (address => bool) public frozenAccount;

  event Withdraw(address indexed from, uint256 amount);

  function donate(address to) public payable {
    require(!frozenAccount[to]);
    credit[to] += msg.value;
  }

  function withdraw(uint amount) public {
    require(!frozenAccount[msg.sender]);
    require(credit[msg.sender] >= amount);
    credit[msg.sender] -= amount;
    msg.sender.transfer(amount);
    emit Withdraw(msg.sender, amount);
  }

  function queryCredit(address to) public view returns (uint){
    return credit[to];
  }

  function freezeAccount(address account) public {
    frozenAccount[account] = true;
  }

  function unfreezeAccount(address account) public {
    frozenAccount[account] = false;
  }
} 

// Changes Made:
// 1. Added events for withdrawal
// 2. Added check to prevent withdrawal if account is frozen
// 3. Used transfer() instead of call.value() to prevent re-entrancy attack
// 4. Added functions to freeze and unfreeze accounts