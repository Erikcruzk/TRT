pragma solidity ^0.4.24;

contract SimpleDAO {
  mapping (address => uint) public credit;

  function donate(address _to) public payable {
    credit[_to] = credit[_to] + msg.value;
  }

  function withdraw(uint _amount) public {
    require(credit[msg.sender] >= _amount);
    credit[msg.sender] = credit[msg.sender] - _amount;
    msg.sender.transfer(_amount);
  }

  function queryCredit(address _to) public view returns (uint){
    return credit[_to];
  }
}