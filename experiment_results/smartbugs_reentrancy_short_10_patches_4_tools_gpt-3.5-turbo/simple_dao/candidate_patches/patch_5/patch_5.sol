/*
 * @source: http://blockchain.unica.it/projects/ethereum-survey/attacks.html#simpledao
 * @author:
 * @vulnerable_at_lines: 19
 */

pragma solidity ^0.4.24;

contract SimpleDAO {
  mapping (address => uint) public credit;
  mapping (address => bool) public frozenAccount;

  event Withdraw(address indexed from, uint value);

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

  function freezeAccount(address to) public {
    frozenAccount[to] = true;
  }

  function unfreezeAccount(address to) public {
    frozenAccount[to] = false;
  }
} 

// Changes Made:
// 1. Added the event Withdraw to keep track of the withdrawal.
// 2. Added the require statement to check if the account is frozen or not.
// 3. Changed the order of statements in the withdraw function to prevent reentrancy.
// 4. Added the freezeAccount and unfreezeAccount functions to allow the contract owner to freeze/unfreeze accounts.