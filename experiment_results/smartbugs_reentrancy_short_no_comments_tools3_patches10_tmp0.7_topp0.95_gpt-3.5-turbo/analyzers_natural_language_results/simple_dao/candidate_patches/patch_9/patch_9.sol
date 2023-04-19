pragma solidity ^0.4.26;

contract SimpleDAO {
  mapping (address => uint256) public credit;

  function donate(address to) public payable {
    credit[to] += msg.value;
  }

  function withdraw(uint256 amount) public {
    require(credit[msg.sender] >= amount);
    credit[msg.sender] -= amount;
    msg.sender.transfer(amount);
  }

  function queryCredit(address to) public view returns (uint256){
    return credit[to];
  }
}