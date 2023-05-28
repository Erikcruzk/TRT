pragma solidity ^0.8.0;

contract Reentrancy_bonus {
    mapping(address => uint) private userBalances;
    mapping(address => bool) private claimedBonus;
    mapping(address => uint) private rewardsForA;

    function withdrawReward(address recipient) public {
        require(rewardsForA[recipient] > 0);
        uint amountToWithdraw = rewardsForA[recipient];
        rewardsForA[recipient] = 0;
        (bool success, ) = recipient.call{value:amountToWithdraw}("");
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
// 1. Updated the compiler version to 0.8.0
// 2. Added require statement to check if the reward is greater than 0 before withdrawing
// 3. Moved the line claimedBonus[recipient] = true; before rewardsForA[recipient] += 100; to prevent reentrancy vulnerability.