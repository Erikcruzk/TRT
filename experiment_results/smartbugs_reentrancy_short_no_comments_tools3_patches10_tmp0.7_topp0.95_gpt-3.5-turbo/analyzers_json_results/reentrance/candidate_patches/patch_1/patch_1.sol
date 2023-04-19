pragma solidity ^0.4.18;

contract Reentrance {
  mapping(address => uint) public balances;
  mapping(address => bool) public isLocked;

  function donate(address _to) public payable {
    balances[_to] += msg.value;
  }

  function balanceOf(address _who) public view returns (uint balance) {
    return balances[_who];
  }

  function withdraw(uint _amount) public {
    require(!isLocked[msg.sender]);
    require(balances[msg.sender] >= _amount);
    isLocked[msg.sender] = true;
    balances[msg.sender] -= _amount;
    if(msg.sender.call.value(_amount)()) {
      isLocked[msg.sender] = false;
    }
  }

  function() public payable {}
} 

// The repaired contract includes a new mapping called isLocked to prevent reentrancy attacks. The function withdraw is updated to first check if the sender is not locked and then sets the lock to true. After that, it checks if the sender has enough balance and then transfers the amount requested. Finally, it sets the lock to false to allow future transactions.