/// Solidity Smart contract vulnerable to reentrancy attack
contract Reentrant {
   mapping(address => uint) public balances;

   function withdraw(uint256 value) public {
      require(balances[msg. sender] > 0, "Please charge your balances first");
      msg.sender.transfer(value);
      balances[msg.sender] = balances[msg.sender] - value;
   }
}
/// Repair of Solidity Smart contract vulnerable to reentrancy attack
contract ReentrantFixed {
   mapping(address => uint) public balances;

   function withdraw(uint256 value) public {
      require(balances[msg. sender] > 0, "Please charge your balances first");
      balances[msg.sender] = balances[msg.sender] - value;
      msg.sender.transfer(value);
   }
}