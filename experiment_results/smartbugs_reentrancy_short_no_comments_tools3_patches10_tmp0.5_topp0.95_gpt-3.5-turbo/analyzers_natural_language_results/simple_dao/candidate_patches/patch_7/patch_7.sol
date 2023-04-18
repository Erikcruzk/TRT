pragma solidity ^0.4.2;

contract SimpleDAO {
  mapping (address => uint) public credit;

  function donate(address to) payable {
    require(msg.value > 0);
    credit[to] = credit[to] + msg.value;
  }

  function withdraw(uint amount) {
    require(credit[msg.sender] >= amount);
    credit[msg.sender] = credit[msg.sender] - amount;
    bool res = msg.sender.call.value(amount)();
    require(res);
  }

  function queryCredit(address to) view returns (uint){
    return credit[to];
  }
}