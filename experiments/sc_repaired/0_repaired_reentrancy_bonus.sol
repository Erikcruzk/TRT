by [user: memect]
/*
 * @source: https://consensys.github.io/smart-contract-best-practices/known_attacks/
 * @author: memect
 * @fixed_at_lines: 19-20
 */

pragma solidity ^0.4.0;

contract Reentrancy_bonus {

    // SECURE
    mapping (address => uint) private userBalances;
    mapping (address => bool) private claimedBonus;
    mapping (address => uint) private rewardsForA;
    bool isInWithdrawal = false;

    function withdrawReward(address recipient) public {
        require(!isInWithdrawal);
        isInWithdrawal = true;
        uint amountToWithdraw = rewardsForA[recipient];
        rewardsForA[recipient] = 0;
        (bool success, ) = recipient.call.value(amountToWithdraw)("");
        require(success);
        isInWithdrawal = false;
    }

    function getFirstWithdrawalBonus(address recipient) public {
        require(!claimedBonus[recipient]); // Each recipient should only be able to claim the bonus once

        rewardsForA[recipient] += 100;
        withdrawReward(recipient); // At this point, the caller will be able to execute getFirstWithdrawalBonus again.
        claimedBonus[recipient] = true;
    }
}



