pragma solidity ^0.4.2;

contract SimpleDAO {
  mapping (address => uint) public credit;

  function donate(address to) payable {
    require(msg.value > 0, "Donation amount should be greater than 0");
    credit[to] += msg.value;
  }

  function withdraw(uint amount) {
    require(amount > 0, "Withdrawal amount should be greater than 0");
    require(credit[msg.sender] >= amount, "Insufficient balance");
    credit[msg.sender] -= amount;
    bool res = msg.sender.call.value(amount)();
    require(res, "Failed to transfer ether");
  }

  function queryCredit(address to) view returns (uint){
    return credit[to];
  }
}