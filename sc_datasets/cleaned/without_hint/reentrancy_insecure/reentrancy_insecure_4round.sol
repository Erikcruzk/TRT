pragma solidity ^0.4.0;

contract Reentrancy_secure {

mapping (address => uint) private userBalances;
mapping (address => bool) private locked;

function withdrawBalance() public {
require(!locked[msg.sender]); 
locked[msg.sender] = true;
uint amountToWithdraw = userBalances[msg.sender];
userBalances[msg.sender] = 0;
msg.sender.transfer(amountToWithdraw);
locked[msg.sender] = false;
}
}