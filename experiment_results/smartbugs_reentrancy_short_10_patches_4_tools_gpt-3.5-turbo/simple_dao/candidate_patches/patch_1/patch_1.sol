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
  event Deposit(address indexed _from, address indexed _to, uint256 _value);
  event FrozenFunds(address target, bool frozen);

  function donate(address to) public payable {
    credit[to] += msg.value;
    emit Deposit(msg.sender, to, msg.value);
  }

  function withdraw(uint amount) public {
    require(!frozenAccount[msg.sender]);
    require(credit[msg.sender] >= amount);
    credit[msg.sender] -= amount;
    msg.sender.transfer(amount);
    emit Withdraw(msg.sender, msg.sender, amount);
  }

  function queryCredit(address to) public view returns (uint) {
    return credit[to];
  }

  function freezeAccount(address target, bool freeze) public {
    frozenAccount[target] = freeze;
    emit FrozenFunds(target, freeze);
  }
}