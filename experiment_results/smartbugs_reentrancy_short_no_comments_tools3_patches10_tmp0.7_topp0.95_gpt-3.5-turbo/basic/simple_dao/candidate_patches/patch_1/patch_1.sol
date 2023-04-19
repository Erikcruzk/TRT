pragma solidity ^0.4.24;

contract SimpleDAO {
  mapping (address => uint) public credit;

  function donate(address to) public payable {
    credit[to] += msg.value;
  }

  function withdraw(uint amount) public {
    require(credit[msg.sender]>= amount, "Insufficient balance"); // added require statement for checking balance
    bool res = msg.sender.send(amount); // changed to send instead of call.value
    require(res, "Failed to send ether"); // added require statement to check if send was successful
    credit[msg.sender]-=amount;
  }

  function queryCredit(address to) public view returns (uint){ // added view keyword to indicate a read-only function
    return credit[to];
  }
}