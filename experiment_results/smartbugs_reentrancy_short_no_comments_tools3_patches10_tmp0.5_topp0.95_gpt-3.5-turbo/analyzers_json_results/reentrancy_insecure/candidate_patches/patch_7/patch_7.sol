pragma solidity ^0.4.0;

contract Reentrancy_fixed {

    mapping (address => uint) private userBalances;

    function withdrawBalance() public {
        uint amountToWithdraw = userBalances[msg.sender];
        userBalances[msg.sender] = 0;
        require(msg.sender.call.value(amountToWithdraw)());
    }
} 

// Changes Made:
// 1. Moved the userBalances[msg.sender] = 0; line before the external call to prevent reentrancy attack.
// 2. Replaced (bool success, ) = msg.sender.call.value(amountToWithdraw)(""); with require(msg.sender.call.value(amountToWithdraw)()); to simplify the code and make it more secure.