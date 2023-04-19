pragma solidity ^0.4.2;

contract SimpleDAO {
  mapping (address => uint) public credit;

  function donate(address to) payable {
    require(msg.value > 0);
    credit[to] = safeAdd(credit[to], msg.value);
  }

  function withdraw(uint amount) {
    require(amount > 0);
    require(credit[msg.sender]>= amount);
    credit[msg.sender] = safeSub(credit[msg.sender], amount);
    bool res = msg.sender.call.value(amount)();
    require(res);
  }

  function queryCredit(address to) public view returns (uint){
    return credit[to];
  }

  function safeAdd(uint a, uint b) internal pure returns (uint) {
    uint c = a + b;
    require(c >= a);
    return c;
  }

  function safeSub(uint a, uint b) internal pure returns (uint) {
    require(b <= a);
    uint c = a - b;
    return c;
  }
}