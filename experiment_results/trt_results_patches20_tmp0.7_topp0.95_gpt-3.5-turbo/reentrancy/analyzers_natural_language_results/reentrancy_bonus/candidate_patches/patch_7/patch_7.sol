pragma solidity ^0.4.24;

contract Reentrancy_bonus {
    mapping(address => uint) private userBalances;
    mapping(address => bool) private claimedBonus;
    mapping(address => uint) private rewardsForA;

    function withdrawReward(address recipient) public {
        require(rewardsForA[recipient] > 0); // Check if reward exists

        uint reward = rewardsForA[recipient];
        rewardsForA[recipient] = 0;

        if (!(recipient.call.value(reward)())) { // Execute external call
            revert(); // Revert if call fails
        }
    }

    function getFirstWithdrawalBonus(address recipient) public {
        require(!claimedBonus[recipient]);

        rewardsForA[recipient] += 100;

        claimedBonus[recipient] = true; // Set claimed bonus to true before executing external call
        withdrawReward(recipient); // Execute external call
    }
}