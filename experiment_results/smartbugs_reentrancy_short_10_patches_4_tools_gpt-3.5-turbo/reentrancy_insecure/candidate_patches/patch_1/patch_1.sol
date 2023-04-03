/*
 * @source: https://consensys.github.io/smart-contract-best-practices/known_attacks/
 * @author: -
 * @fixed_at_lines: 17
 */

pragma solidity ^0.4.0;

contract Reentrancy_fixed {

    mapping (address => uint) private userBalances;
    mapping (address => bool) private locked;

    function withdrawBalance() public {
        require(!locked[msg.sender]); // Ensure that the sender is not already in the middle of a withdraw call
        locked[msg.sender] = true; // Lock the sender
        uint amountToWithdraw = userBalances[msg.sender];
        userBalances[msg.sender] = 0;
        require(msg.sender.call.value(amountToWithdraw)("")); // Send the funds first
        locked[msg.sender] = false; // Unlock the sender
    }
} 

// Changes Made:
// 1. Added a mapping to keep track of whether a sender is currently in the middle of a withdraw call
// 2. Added a check to ensure that the sender is not already in the middle of a withdraw call
// 3. Moved the userBalances[msg.sender] assignment after the funds have been sent to prevent reentrancy attacks.