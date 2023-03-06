pragma solidity ^0.4.18;

contract Reentrance {

  mapping(address => uint) public balances;
  mapping(address => bool) internal ddos;

  function donate(address _to) public payable {
    balances[_to] += msg.value;
  }

  function balanceOf(address _who) public view returns (uint balance) {
    return balances[_who];
  }

  function withdraw(uint _amount) public {
    if (balances[msg.sender] >= _amount && !ddos[msg.sender]) {
      ddos[msg.sender] = true;
      msg.sender.call.value(_amount)();
      balances[msg.sender] -= _amount;
      ddos[msg.sender] = false;
    }
  }

  function() public payable {}
}