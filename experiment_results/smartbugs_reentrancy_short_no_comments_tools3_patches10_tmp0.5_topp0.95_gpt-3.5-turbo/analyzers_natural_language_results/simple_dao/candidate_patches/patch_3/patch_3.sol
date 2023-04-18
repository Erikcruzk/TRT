pragma solidity ^0.4.24;

contract SimpleDAO {
  mapping (address => uint) public credit;

  function donate(address to) public payable {
    require(to != address(0)); // added to prevent sending funds to the zero address
    credit[to] = credit[to] + msg.value;
  }

  function withdraw(uint amount) public {
    require(amount > 0 && credit[msg.sender] >= amount); // added to prevent withdrawing a negative amount or more than the credit balance
    credit[msg.sender] = credit[msg.sender] - amount;
    bool res = msg.sender.call.value(amount)();
    require(res); // added to check if the external call was successful
  }

  function queryCredit(address to) public view returns (uint){
    return credit[to];
  }
}