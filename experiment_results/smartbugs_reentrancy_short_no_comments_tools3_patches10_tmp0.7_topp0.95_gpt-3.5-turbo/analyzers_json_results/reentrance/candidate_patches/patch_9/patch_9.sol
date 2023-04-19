pragma solidity ^0.4.18;

contract Reentrance {

  mapping(address => uint) public balances;
  mapping(address => bool) public locked;

  function donate(address _to) public payable {
    require(!locked[_to]); // Check if the account is not locked
    balances[_to] += msg.value;
  }

  function balanceOf(address _who) public view returns (uint balance) {
    return balances[_who];
  }

  function withdraw(uint _amount) public {
    require(!locked[msg.sender]); // Check if the account is not locked
    require(balances[msg.sender] >= _amount);

    locked[msg.sender] = true; // Lock the account
    msg.sender.transfer(_amount);
    balances[msg.sender] -= _amount;
    locked[msg.sender] = false; // Unlock the account
  }

  function() public payable {}
}