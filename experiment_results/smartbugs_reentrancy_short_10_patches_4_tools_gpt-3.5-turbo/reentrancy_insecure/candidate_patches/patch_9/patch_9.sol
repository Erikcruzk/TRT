/*
 * @source: https://consensys.github.io/smart-contract-best-practices/known_attacks/
 * @author: -
 * @fixed_at_lines: 17
 */

pragma solidity ^0.8.0;

contract Reentrancy_secure {

    mapping (address => uint) private userBalances;
    mapping (address => bool) private locked;

    function withdrawBalance() public {
        require(!locked[msg.sender], "Withdraw already in progress");
        uint amountToWithdraw = userBalances[msg.sender];
        require(amountToWithdraw > 0, "No balance to withdraw");
        locked[msg.sender] = true;
        userBalances[msg.sender] = 0;
        (bool success, ) = msg.sender.call{value: amountToWithdraw}("");
        require(success, "Transfer failed");
        locked[msg.sender] = false;
    }
} 

// Changes Made:
// 1. Updated the solidity version to 0.8.0.
// 2. Added a "locked" mapping to keep track of whether a withdrawal is already in progress for a user.
// 3. Added a check to ensure that a user doesn't have a withdrawal already in progress.
// 4. Moved the balance update and locked status update before the external call to prevent reentrancy attacks.
// 5. Added a require statement to check if the user has any balance to withdraw.
// 6. Added an error message to the require statements for better debugging.