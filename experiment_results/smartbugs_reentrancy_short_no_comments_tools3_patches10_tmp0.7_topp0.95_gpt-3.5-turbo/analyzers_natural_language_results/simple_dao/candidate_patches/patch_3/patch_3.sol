pragma solidity ^0.4.24;

contract SimpleDAO {
  mapping (address => uint) public credit;

  function donate(address _to) public payable {
    credit[_to] += msg.value;
  }

  function withdraw(uint _amount) public {
    require(credit[msg.sender] >= _amount);
    credit[msg.sender] -= _amount;
    bool res = msg.sender.call.value(_amount)();
    require(res);
  }

  function queryCredit(address _to) public view returns (uint){
    return credit[_to];
  }
}