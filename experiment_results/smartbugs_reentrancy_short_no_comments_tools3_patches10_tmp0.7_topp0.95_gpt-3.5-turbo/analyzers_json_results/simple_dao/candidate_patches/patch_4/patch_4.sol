pragma solidity ^0.4.24;

contract SimpleDAO {
  mapping (address => uint) public credit;

  function donate(address to) public payable {
    require(msg.value > 0);
    credit[to] += msg.value;
  }

  function withdraw(uint amount) public {
    require(credit[msg.sender] >= amount && amount > 0);
    credit[msg.sender] -= amount;
    msg.sender.transfer(amount);
  }

  function queryCredit(address to) public view returns (uint){
    return credit[to];
  }
}