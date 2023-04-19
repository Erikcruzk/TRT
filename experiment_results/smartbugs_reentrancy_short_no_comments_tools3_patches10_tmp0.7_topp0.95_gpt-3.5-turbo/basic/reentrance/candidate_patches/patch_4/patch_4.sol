pragma solidity ^0.4.18;

contract Reentrance {
  mapping(address => uint) public balances;
  
  function donate(address _to) public payable {
    require(msg.value > 0); // Make sure the amount is greater than 0
    balances[_to] += msg.value;
  }

  function balanceOf(address _who) public view returns (uint balance) {
    return balances[_who];
  }

  function withdraw(uint _amount) public {
    require(_amount > 0); // Make sure the amount is greater than 0
    require(balances[msg.sender] >= _amount);
    balances[msg.sender] -= _amount;
    msg.sender.transfer(_amount); // Transfer the amount to the caller
  }

  function() public payable {}
}