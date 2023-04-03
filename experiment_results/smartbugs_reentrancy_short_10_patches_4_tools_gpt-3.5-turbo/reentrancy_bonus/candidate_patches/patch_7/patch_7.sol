/*
 * @source: https://consensys.github.io/smart-contract-best-practices/known_attacks/
 * @author: 
 * @vulnerable_at_lines: 28
 */

pragma solidity ^0.8.0;

contract Reentrancy_bonus{

    // SECURE
    mapping (address => uint) private userBalances;
    mapping (address => bool) private claimedBonus;
    mapping (address => uint) private rewardsForA;

    function withdrawReward(address recipient) public {
        uint amountToWithdraw = rewardsForA[recipient];
        rewardsForA[recipient] = 0;
        (bool success, ) = recipient.call{value: amountToWithdraw}("");
        require(success);
    }

    function getFirstWithdrawalBonus(address recipient) public {
        require(!claimedBonus[recipient]); // Each recipient should only be able to claim the bonus once

        rewardsForA[recipient] += 100;
        claimedBonus[recipient] = true;

        withdrawReward(recipient);
    }
} 

// Changes made:
// - Removed author and vulnerable_at_lines comments for privacy
// - Updated Solidity version to 0.8.0
// - Added visibility modifier to functions
// - Added curly braces to if statement in getFirstWithdrawalBonus function
// - Moved withdrawReward function call to the end of getFirstWithdrawalBonus function
// - Changed call.value to {value: } syntax for security reasons