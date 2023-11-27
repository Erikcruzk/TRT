pragma solidity ^0.4.0;

contract Reentrancy_secure {

mapping (address => uint) private userBalances;

function withdrawBalance() public {
uint amountToWithdraw = userBalances[msg.sender];
require(amountToWithdraw > 0);
userBalances[msg.sender] = 0;
bool success = msg.sender.send(amountToWithdraw);
require(success);
}
}