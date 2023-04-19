pragma solidity ^0.4.24;

contract SimpleDAO {
  mapping (address => uint) public credit;

  function donate(address to) public payable {
    credit[to] += msg.value;
  }

  function withdraw(uint amount) public {
    require(credit[msg.sender] >= amount, "Insufficient balance"); // added require statement for better security
    bool res = msg.sender.send(amount); // changed call to send for better security
    if (res) {
      credit[msg.sender] -= amount;
    }
  }

  function queryCredit(address to) public view returns (uint){ // added view keyword for better security
    return credit[to];
  }
}