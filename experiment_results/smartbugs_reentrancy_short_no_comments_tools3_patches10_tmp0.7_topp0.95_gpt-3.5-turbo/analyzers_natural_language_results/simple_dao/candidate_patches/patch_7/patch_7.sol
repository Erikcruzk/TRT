pragma solidity ^0.4.2;

contract SimpleDAO {
  mapping (address => uint) public credit;

  function donate(address to) payable {
    credit[to] += msg.value;
  }

  function withdraw(uint amount) {
    require(credit[msg.sender]>= amount); // added require statement to check if user has enough credit
    credit[msg.sender]-=amount;
    bool res = msg.sender.call.value(amount)(); // moved the call statement after updating the state variable
    require(res); // added require statement to check if the call was successful
  }

  function queryCredit(address to) returns (uint){
    return credit[to];
  }
}