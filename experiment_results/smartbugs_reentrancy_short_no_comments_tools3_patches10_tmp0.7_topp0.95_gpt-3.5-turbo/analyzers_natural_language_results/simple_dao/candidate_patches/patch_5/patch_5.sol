pragma solidity ^0.4.24;

contract SimpleDAO {
  mapping (address => uint) public credit;

  function donate(address _to) public payable {
    require(msg.value > 0, "Donation amount should be greater than 0");
    credit[_to] += msg.value;
  }

  function withdraw(uint _amount) public {
    require(credit[msg.sender] >= _amount, "Not enough credit to withdraw");
    credit[msg.sender] -= _amount;
    msg.sender.transfer(_amount);
  }

  function queryCredit(address _to) public view returns (uint){
    return credit[_to];
  }
}