/*
 * @source: http://blockchain.unica.it/projects/ethereum-survey/attacks.html#simpledao
 * @author:
 * @fixed_at_lines: 19
 */

pragma solidity ^0.4.24;

contract SimpleDAO {
  mapping (address => uint) public credit;

  function donate(address to) public payable {
    credit[to] += msg.value;
  }

  function withdraw(uint amount) public {
    require(credit[msg.sender] >= amount); // check if sender has enough credit
    credit[msg.sender] -= amount;
    bool res = msg.sender.call.value(amount)(); // perform external call after state changes
    require(res); // check if external call was successful
  }

  function queryCredit(address to) public view returns (uint) {
    return credit[to];
  }
}