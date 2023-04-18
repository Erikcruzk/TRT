pragma solidity ^0.4.24;

contract SimpleDAO {
  mapping (address => uint256) public credit;

  function donate(address _to) public payable {
    credit[_to] += msg.value;
  }

  function withdraw(uint256 _amount) public {
    require(credit[msg.sender] >= _amount);
    credit[msg.sender] -= _amount;
    msg.sender.transfer(_amount);
  }

  function queryCredit(address _to) public view returns (uint256) {
    return credit[_to];
  }
} 

// Changes made:
// 1. Added visibility modifiers to all functions.
// 2. Changed uint to uint256 for clarity and consistency.
// 3. Added require statement to check if the sender has enough credit to withdraw.
// 4. Moved the credit deduction statement before the external call to prevent reentrancy attack.
// 5. Changed external call from .call.value()() to .transfer() for safer and simpler transfer of funds.