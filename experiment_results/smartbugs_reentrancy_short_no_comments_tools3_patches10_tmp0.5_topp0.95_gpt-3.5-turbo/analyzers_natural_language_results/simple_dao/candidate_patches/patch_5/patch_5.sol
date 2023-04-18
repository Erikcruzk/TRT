pragma solidity ^0.4.24;

contract SimpleDAO {
  mapping (address => uint) public credit;

  function donate(address to) public payable {
    require(to != address(0), "Invalid recipient address");
    credit[to] += msg.value;
  }

  function withdraw(uint amount) public {
    require(credit[msg.sender] >= amount, "Insufficient balance");
    credit[msg.sender] -= amount;
    msg.sender.transfer(amount);
  }

  function queryCredit(address to) public view returns (uint){
    require(to != address(0), "Invalid recipient address");
    return credit[to];
  }
}