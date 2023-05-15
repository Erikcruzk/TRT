pragma solidity ^0.4.24;

contract Reentrancy_bonus {
    mapping(address => uint) private userBalances;
    mapping(address => bool) private claimedBonus;
    mapping(address => uint) private rewardsForA;

    function withdrawReward(address recipient) public {
        require(rewardsForA[recipient] > 0);
        uint amountToWithdraw = rewardsForA[recipient];
        rewardsForA[recipient] = 0;
        bool success = false;
        (success, ) = recipient.call.value(amountToWithdraw)("");
        require(success);
    }

    function getFirstWithdrawalBonus(address recipient) public {
        require(!claimedBonus[recipient]);
        claimedBonus[recipient] = true;
        rewardsForA[recipient] += 100;
        withdrawReward(recipient);
    }
}

// Changes Made:
// 1. Updated the Solidity version to ^0.4.24
// 2. Added a check to ensure that the reward amount to withdraw is greater than zero
// 3. Reordered the function calls in getFirstWithdrawalBonus to first mark the bonus as claimed before adding the reward and withdrawing it.