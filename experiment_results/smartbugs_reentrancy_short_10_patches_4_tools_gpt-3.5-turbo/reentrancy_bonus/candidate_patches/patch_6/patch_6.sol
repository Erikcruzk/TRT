/*
 * @source: https://consensys.github.io/smart-contract-best-practices/known_attacks/
 * @author: consensys
 * @fixed_by: aditya-kunjapur
 * @vulnerable_at_lines: 28
 */

pragma solidity ^0.4.0;

contract Reentrancy_bonus{

    // FIXED
    mapping (address => uint) private userBalances;
    mapping (address => bool) private claimedBonus;
    mapping (address => uint) private rewardsForA;
    bool private reentrancy_lock = false;

    function withdrawReward(address recipient) public {
        require(!reentrancy_lock);
        reentrancy_lock = true;
        uint amountToWithdraw = rewardsForA[recipient];
        rewardsForA[recipient] = 0;
        (bool success, ) = recipient.call.value(amountToWithdraw)("");
        require(success);
        reentrancy_lock = false;
    }

    function getFirstWithdrawalBonus(address recipient) public {
        require(!claimedBonus[recipient]); // Each recipient should only be able to claim the bonus once

        rewardsForA[recipient] += 100;
        claimedBonus[recipient] = true;
        // <yes> <report> REENTRANCY
        withdrawReward(recipient); // At this point, the caller will not be able to execute getFirstWithdrawalBonus again.
    }
}