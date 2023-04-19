pragma solidity ^0.4.24;

contract SimpleDAO {
  mapping (address => uint) public credit;

  function donate(address _to) public payable {
    credit[_to] += msg.value;
  }

  function withdraw(uint _amount) public {
    require(credit[msg.sender] >= _amount); // add require statement to check if sender has enough credit
    bool res = msg.sender.send(_amount); // use send() instead of call.value()
    require(res); // add require statement to check if transfer was successful
    credit[msg.sender] -= _amount;
  }

  function queryCredit(address _to) public view returns (uint) { // add view keyword
    return credit[_to];
  }
}