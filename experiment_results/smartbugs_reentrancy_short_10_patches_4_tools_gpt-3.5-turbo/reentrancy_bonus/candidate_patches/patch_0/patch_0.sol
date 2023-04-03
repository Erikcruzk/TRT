/*
 * @source: https://consensys.github.io/smart-contract-best-practices/known_attacks/
 * @author: consensys
 * @vulnerable_at_lines: 28
 */

pragma solidity ^0.8.0;

contract Reentrancy_bonus{

    mapping (address => uint) private userBalances;
    mapping (address => bool) private claimedBonus;
    mapping (address => uint) private rewardsForA;

    function withdrawReward(address recipient) public {
        uint amountToWithdraw = rewardsForA[recipient];
        rewardsForA[recipient] = 0;
        (bool success, ) = recipient.call{value: amountToWithdraw}("");
        require(success, "Transfer failed.");
    }

    function getFirstWithdrawalBonus(address recipient) public {
        require(!claimedBonus[recipient], "Bonus already claimed."); // Each recipient should only be able to claim the bonus once

        rewardsForA[recipient] += 100;
        claimedBonus[recipient] = true;
        withdrawReward(recipient);
    }
} 

// Changes Made:
// 1. Updated Solidity version to 0.8.0
// 2. Removed insecure mappings
// 3. Added error messages to require statements
// 4. Moved the withdrawReward function call after the claimedBonus mapping is updated to prevent reentrancy vulnerability.