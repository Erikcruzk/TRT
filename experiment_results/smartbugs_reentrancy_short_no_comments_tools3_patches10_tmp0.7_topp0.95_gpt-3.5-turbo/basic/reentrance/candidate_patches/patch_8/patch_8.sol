pragma solidity ^0.4.18;

contract Reentrance {
  mapping(address => uint) public balances;
  
  function donate(address _to) public payable {
    require(_to != address(0));
    balances[_to] += msg.value;
  }

  function balanceOf(address _who) public view returns (uint balance) {
    return balances[_who];
  }

  function withdraw(uint _amount) public {
    require(_amount <= balances[msg.sender]);
    balances[msg.sender] -= _amount;
    msg.sender.transfer(_amount);
  }

  function() public payable {}
}