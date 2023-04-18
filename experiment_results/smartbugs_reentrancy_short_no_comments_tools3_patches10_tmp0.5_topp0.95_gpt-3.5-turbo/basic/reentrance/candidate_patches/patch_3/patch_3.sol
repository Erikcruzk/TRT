pragma solidity ^0.4.18;

contract Reentrance {
  mapping(address => uint) public balances;
  bool private locked;

  modifier noReentrancy() {
    require(!locked);
    locked = true;
    _;
    locked = false;
  }

  function donate(address _to) public payable {
    balances[_to] += msg.value;
  }

  function balanceOf(address _who) public view returns (uint balance) {
    return balances[_who];
  }

  function withdraw(uint _amount) public noReentrancy {
    require(balances[msg.sender] >= _amount);
    balances[msg.sender] -= _amount;
    msg.sender.transfer(_amount);
  }

  function() public payable {}
}