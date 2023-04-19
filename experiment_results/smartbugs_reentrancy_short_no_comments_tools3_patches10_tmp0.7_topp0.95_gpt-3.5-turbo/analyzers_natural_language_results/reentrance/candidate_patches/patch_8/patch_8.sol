pragma solidity ^0.4.18;

contract Reentrance {
  mapping(address => uint256) public balances;
  mapping(address => bool) public locked;
  
  function donate(address _to) public payable {
    balances[_to] += msg.value;
  }

  function balanceOf(address _who) public view returns (uint256 balance) {
    return balances[_who];
  }

  function withdraw(uint256 _amount) public {
    require(!locked[msg.sender]);
    require(balances[msg.sender] >= _amount);
    locked[msg.sender] = true;
    msg.sender.transfer(_amount);
    balances[msg.sender] -= _amount;
    locked[msg.sender] = false;
  }

  function() public payable {}
}