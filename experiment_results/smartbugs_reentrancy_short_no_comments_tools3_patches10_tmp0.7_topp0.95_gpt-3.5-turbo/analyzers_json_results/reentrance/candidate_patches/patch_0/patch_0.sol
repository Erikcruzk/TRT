pragma solidity ^0.4.18;

contract Reentrance {
  mapping(address => uint256) private balances;

  function donate(address _to) public payable {
    require(_to != address(0));
    balances[_to] += msg.value;
  }

  function balanceOf(address _who) public view returns (uint256 balance) {
    return balances[_who];
  }

  function withdraw(uint256 _amount) public {
    require(balances[msg.sender] >= _amount);
    balances[msg.sender] -= _amount;
    msg.sender.transfer(_amount);
  }

  function() public payable {}
}