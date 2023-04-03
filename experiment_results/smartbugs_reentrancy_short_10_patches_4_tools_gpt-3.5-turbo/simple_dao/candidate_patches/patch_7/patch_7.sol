/*
 * @source: http://blockchain.unica.it/projects/ethereum-survey/attacks.html#simpledao
 * @author:
 * @vulnerable_at_lines: 19
 */

pragma solidity ^0.4.26;

contract SimpleDAO {
  mapping (address => uint) public credit;
  mapping (address => bool) public frozenAccount;

  event Withdraw(address indexed _from, address indexed _to, uint256 _value);
  event Deposit(address indexed _from, uint256 _value);

  function donate(address to) public payable {
    require(!frozenAccount[to]);
    credit[to] += msg.value;
    emit Deposit(msg.sender, msg.value);
  }

  function withdraw(uint amount) public {
    require(!frozenAccount[msg.sender]);
    require(credit[msg.sender] >= amount);
    credit[msg.sender] -= amount;
    emit Withdraw(msg.sender, msg.sender, amount);
    msg.sender.transfer(amount);
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