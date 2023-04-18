pragma solidity ^0.4.24;

contract SimpleDAO {
  mapping (address => uint) public credit;

  function donate(address to) public payable {
    credit[to] = credit[to] + msg.value;
  }

  function withdraw(uint amount) public {
    require(credit[msg.sender] >= amount, "Insufficient balance");
    credit[msg.sender] = credit[msg.sender] - amount;
    msg.sender.transfer(amount);
  }

  function queryCredit(address to) public view returns (uint){
    return credit[to];
  }
}