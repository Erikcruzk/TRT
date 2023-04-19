pragma solidity ^0.8.0;

contract SimpleDAO {
  mapping (address => uint) public credit;
  mapping (address => bool) public isLocked;

  function donate(address to) external payable {
    credit[to] += msg.value;
  }

  function withdraw(uint amount) external {
    require(!isLocked[msg.sender], "Account is locked.");
    require(credit[msg.sender]>= amount, "Insufficient balance.");
    isLocked[msg.sender] = true;
    credit[msg.sender]-=amount;
    (bool res, ) = msg.sender.call{value: amount}("");
    require(res, "Withdrawal failed.");
    isLocked[msg.sender] = false;
  }

  function queryCredit(address to) external view returns (uint){
    return credit[to];
  }
}