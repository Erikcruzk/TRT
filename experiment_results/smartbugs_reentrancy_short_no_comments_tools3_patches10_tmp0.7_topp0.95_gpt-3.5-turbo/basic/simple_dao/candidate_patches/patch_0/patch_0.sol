pragma solidity ^0.4.24;

contract SimpleDAO {
  mapping (address => uint) public credit;

  function donate(address _to) public payable {
    credit[_to] += msg.value;
  }

  function withdraw(uint _amount) public {
    require(credit[msg.sender] >= _amount, "Insufficient balance");
    credit[msg.sender] -= _amount;
    bool res = msg.sender.send(_amount);
    require(res, "Transfer failed");
  }

  function queryCredit(address _to) public view returns (uint){
    return credit[_to];
  }
}