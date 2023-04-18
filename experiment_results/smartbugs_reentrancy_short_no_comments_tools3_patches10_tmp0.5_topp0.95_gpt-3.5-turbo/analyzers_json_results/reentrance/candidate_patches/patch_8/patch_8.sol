pragma solidity ^0.4.18;

contract Reentrance {

  mapping(address => uint) public balances;

  function donate(address _to) public payable {
    require(_to != address(0)); // prevent donation to the zero address
    balances[_to] += msg.value;
  }

  function balanceOf(address _who) public view returns (uint balance) {
    return balances[_who];
  }

  function withdraw(uint _amount) public {
    require(_amount > 0 && balances[msg.sender] >= _amount); // prevent negative and overdrawn balance
    balances[msg.sender] -= _amount;
    msg.sender.transfer(_amount); // use transfer() instead of call.value()
  }

  function() public payable {}
}