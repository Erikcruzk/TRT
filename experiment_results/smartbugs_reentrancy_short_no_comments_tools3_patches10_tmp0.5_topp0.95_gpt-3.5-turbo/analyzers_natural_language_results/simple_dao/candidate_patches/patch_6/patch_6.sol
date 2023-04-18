pragma solidity ^0.4.24;

contract SimpleDAO {
  mapping (address => uint) public credit;

  function donate(address to) public payable {
    require(to != address(0)); // Prevent donating to address 0x0
    credit[to] += msg.value;
  }

  function withdraw(uint amount) public {
    require(amount > 0); // Prevent withdrawing 0 or negative amount
    require(credit[msg.sender] >= amount); // Require sender to have enough credit
    credit[msg.sender] -= amount;
    msg.sender.transfer(amount);
  }

  function queryCredit(address to) public view returns (uint){
    return credit[to];
  }
}