/*
 * @source: https://consensys.github.io/smart-contract-best-practices/known_attacks/
 * @author: 
 * @fixed_at_lines: 17
 */

pragma solidity ^0.4.0;

contract Reentrancy_secure {

    // SECURE
    mapping (address => uint) private userBalances;
    mapping (address => bool) private locked;

    function withdrawBalance() public {
        require(!locked[msg.sender]); // Check if the user is not already in a withdrawal process
        locked[msg.sender] = true; // Lock the user
        uint amountToWithdraw = userBalances[msg.sender];
        userBalances[msg.sender] = 0; // Update the user balance before sending funds
        (bool success, ) = msg.sender.call.value(amountToWithdraw)(""); // Send funds
        require(success);
        locked[msg.sender] = false; // Unlock the user
    }
} 

// Changes Made:
// 1. Added a "locked" mapping to keep track of users already in a withdrawal process
// 2. Moved the update of the user balance before sending funds to avoid reentrancy attacks
// 3. Added a check to ensure that the user is not already in a withdrawal process