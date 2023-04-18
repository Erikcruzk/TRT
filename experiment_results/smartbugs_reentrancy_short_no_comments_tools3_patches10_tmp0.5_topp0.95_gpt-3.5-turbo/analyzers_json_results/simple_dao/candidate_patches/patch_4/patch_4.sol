pragma solidity ^0.4.2;

contract SimpleDAO {
  mapping (address => uint) public credit;

  function donate(address to) payable {
    require(msg.value > 0);
    credit[to] += msg.value;
  }

  function withdraw(uint amount) {
    require(credit[msg.sender] >= amount);
    credit[msg.sender] -= amount;
    require(msg.sender.call.value(amount)());
  }

  function queryCredit(address to) public view returns (uint){
    return credit[to];
  }
}