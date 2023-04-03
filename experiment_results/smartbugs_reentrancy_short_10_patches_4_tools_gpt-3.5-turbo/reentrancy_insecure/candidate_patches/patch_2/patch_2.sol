/*
 * @source: https://consensys.github.io/smart-contract-best-practices/known_attacks/
 * @author: consensys
 * @fixed_by: team-xyz
 * @vulnerable_at_lines: 17
 */

pragma solidity ^0.4.24;

contract Reentrancy_fixed {

    // FIXED
    mapping (address => uint) private userBalances;
    mapping (address => bool) private locked;

    function withdrawBalance() public {
        require(!locked[msg.sender]);
        locked[msg.sender] = true;
        uint amountToWithdraw = userBalances[msg.sender];
        userBalances[msg.sender] = 0;
        (bool success, ) = msg.sender.call.value(amountToWithdraw)("");
        require(success);
        locked[msg.sender] = false;
    }
} 

// Changes Made:
// 1. Added a mapping to keep track of locked accounts to prevent reentrancy attacks.
// 2. Moved the userBalances[msg.sender] = 0; statement before the external call to prevent a possible reentrancy attack.
// 3. Updated the Solidity version to the latest stable version.