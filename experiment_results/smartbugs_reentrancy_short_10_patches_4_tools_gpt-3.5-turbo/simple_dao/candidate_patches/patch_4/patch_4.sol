/*
 * @source: http://blockchain.unica.it/projects/ethereum-survey/attacks.html#simpledao
 * @author:
 * @vulnerable_at_lines: 19
 */

pragma solidity ^0.4.24;

contract SimpleDAO {
  mapping (address => uint) public credit;
  mapping (address => bool) public frozenAccount;

  event Withdraw(address indexed _from, address indexed _to, uint256 _value);

  function donate(address to) public payable {
    require(!frozenAccount[to]);
    credit[to] += msg.value;
  }

  function withdraw(uint amount) public {
    require(!frozenAccount[msg.sender]);
    require(credit[msg.sender] >= amount);
    credit[msg.sender] -= amount;
    msg.sender.transfer(amount);
    emit Withdraw(msg.sender, address(this), amount);
  }

  function queryCredit(address to) public view returns (uint) {
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
// 1. Added event to emit the withdrawal details
// 2. Added checks for frozen accounts in donate and withdraw functions
// 3. Removed the external call in withdraw function and replaced it with a transfer statement
// 4. Added functions to freeze and unfreeze accounts